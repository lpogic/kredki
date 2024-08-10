#include "wg_window.h"

namespace pas {

#ifdef THORVG_WG_RASTER_SUPPORT

WgWindow::WgWindow(uint32_t width, uint32_t height) : Window() {
    sdl_window = SDL_CreateWindow("Titless", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_HIDDEN);

    //Here we create our WebGPU surface from the window!
    SDL_SysWMinfo windowWMInfo;
    SDL_VERSION(&windowWMInfo.version);
    SDL_GetWindowWMInfo(sdl_window, &windowWMInfo);

    //Init WebGPU
    WGPUInstanceDescriptor desc = {.nextInChain = nullptr};
    instance = wgpuCreateInstance(&desc);

    #if defined(SDL_VIDEO_DRIVER_COCOA)
        [windowWMInfo.info.cocoa.window.contentView setWantsLayer:YES];
        auto layer = [CAMetalLayer layer];
        [windowWMInfo.info.cocoa.window.contentView setLayer:layer];

        WGPUSurfaceDescriptorFromMetalLayer surfaceNativeDesc = {
            .chain = {nullptr, WGPUSType_SurfaceDescriptorFromMetalLayer},
            .layer = layer
        };
    #elif defined(SDL_VIDEO_DRIVER_X11)
        WGPUSurfaceDescriptorFromXlibWindow surfaceNativeDesc = {
            .chain = {nullptr, WGPUSType_SurfaceDescriptorFromXlibWindow},
            .display = windowWMInfo.info.x11.display,
            .window = windowWMInfo.info.x11.window
        };
    #elif defined(SDL_VIDEO_DRIVER_WAYLAND)
        WGPUSurfaceDescriptorFromWaylandSurface surfaceNativeDesc = {
            .chain = {nullptr, WGPUSType_SurfaceDescriptorFromWaylandSurface},
            .display = windowWMInfo.info.wl.display,
            .surface = windowWMInfo.info.wl.surface
        };
    #elif defined(SDL_VIDEO_DRIVER_WINDOWS)
        WGPUSurfaceDescriptorFromWindowsHWND surfaceNativeDesc = {
            .chain = {nullptr, WGPUSType_SurfaceDescriptorFromWindowsHWND},
            .hinstance = GetModuleHandle(nullptr),
            .hwnd = windowWMInfo.info.win.window
        };
    #endif

    WGPUSurfaceDescriptor surfaceDesc{};
    surfaceDesc.nextInChain = (const WGPUChainedStruct*)&surfaceNativeDesc;
    surfaceDesc.label = "The surface";
    surface = wgpuInstanceCreateSurface(instance, &surfaceDesc);

    this->initialize();
}

void WgWindow::initialize() {
    //Create a Canvas
    canvas = tvg::WgCanvas::gen();
    if (!canvas) {
        cout << "WgCanvas is not supported. Did you enable the WgEngine?" << endl;
        return false;
    }

    resize();
}

WgWindow::~WgWindow() {
    //wgpuSurfaceRelease(surface);
    wgpuInstanceRelease(instance);
    if(canvas) {
        canvas->paints().clear(); // prevent free duplicate (all paints are freed by host)
    }
}

tvg::Canvas* WgWindow::getCanvas()  { 
    return canvas->get();
}

void WgWindow::resize() {
    int width, height;
    SDL_GetWindowSize(sdl_window, &width, &height);

    canvas->sync();
    verify(canvas->target(instance, surface, width, height));
    canvas->update(nullptr);
}

bool WgWindow::syncAndUpdateSurface() {
    return verify(canvas->sync());
}

#endif

}