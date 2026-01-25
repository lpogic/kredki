#include "gl_window.h"

namespace pastele {

GlWindow::GlWindow(uint32_t width, uint32_t height) : Window()
{
    sdl_window = SDL_CreateWindow("Titless", width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN);
    context = SDL_GL_CreateContext(sdl_window);
    this->initialize();
}

void GlWindow::initialize()
{
    //Create a Canvas
    canvas = tvg::GlCanvas::gen();
    if (!canvas) {
        cout << "GlCanvas is not supported. Did you enable the GlEngine?" << endl;
        return;
    }

    resize();
}

GlWindow::~GlWindow()
{
    SDL_GL_DestroyContext(context);
}

tvg::Canvas* GlWindow::getCanvas() 
{ 
    return canvas;
}

void GlWindow::resize()
{
    int width, height;
    SDL_GetWindowSize(sdl_window, &width, &height);

    canvas->sync();
    verify(canvas->target(nullptr, nullptr, context, 0, width, height, tvg::ColorSpace::ABGR8888S));
    canvas->update();
}

bool GlWindow::syncAndUpdateSurface()
{
    //Draw the contents to the Canvas
    if (verify(canvas->sync())) {
        SDL_GL_SwapWindow(sdl_window);
        return true;
    }

    return false;
}

}