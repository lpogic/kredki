#ifndef __WG_WINDOW_H__
#define __WG_WINDOW_H__

#include "window.h"

namespace pas {

#ifdef THORVG_WG_RASTER_SUPPORT

class WgWindow : Window
{
    unique_ptr<tvg::WgCanvas> canvas = nullptr;

    WGPUInstance instance;
    WGPUSurface surface;

    public:

    WgWindow(uint32_t width, uint32_t height);
    void initialize();
    virtual ~WgWindow();

    tvg::Canvas* getCanvas();
    void resize();
    bool syncAndUpdateSurface();
};

#else

class WgWindow : Window
{
    public:

    WgWindow(uint32_t width, uint32_t height)
    {
        cout << "webgpu driver is not detected!" << endl;
    }
};

#endif

}

#endif // __WG_WINDOW_H__