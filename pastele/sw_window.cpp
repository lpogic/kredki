#include "sw_window.h"

namespace pas {

SwWindow::SwWindow(uint32_t width, uint32_t height) : Window()
{
    sdl_window = SDL_CreateWindow("Titless", width, height, SDL_WINDOW_HIDDEN);
    this->initialize();
}

SwWindow::~SwWindow()
{
}

void SwWindow::initialize()
{
    //Create a Canvas
    canvas = tvg::SwCanvas::gen();
    if (!canvas) {
        cout << "SwCanvas is not supported. Did you enable the SwEngine?" << endl;
        return;
    }

    resize();
}

tvg::Canvas* SwWindow::getCanvas() 
{ 
    return canvas;
}

void SwWindow::resize()
{
    auto surface = SDL_GetWindowSurface(sdl_window);
    if (!surface) return;

    canvas->sync();
    verify(canvas->target((uint32_t*)surface->pixels, surface->w, surface->pitch / 4, surface->h, tvg::ColorSpace::ARGB8888));
    canvas->update();
}

bool SwWindow::syncAndUpdateSurface()
{
    if (verify(canvas->sync())) {
        SDL_UpdateWindowSurface(sdl_window);
        return true;
    }

    return false;
}

}