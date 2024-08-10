#include "gl_window.h"

namespace pas {

GlWindow::GlWindow(uint32_t width, uint32_t height) : Window()
{
    sdl_window = SDL_CreateWindow("Titless", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN);
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
    SDL_GL_DeleteContext(context);
    if(canvas) {
        canvas->paints().clear(); // prevent free duplicate (all paints are freed by host)
    }
}

tvg::Canvas* GlWindow::getCanvas() 
{ 
    return canvas.get();
}

void GlWindow::resize()
{
    int width, height;
    SDL_GetWindowSize(sdl_window, &width, &height);

    canvas->sync();
    verify(canvas->target(0, width, height));
    canvas->update(nullptr);
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