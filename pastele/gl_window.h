#ifndef __GL_WINDOW_H__
#define __GL_WINDOW_H__

#include "window.h"

namespace pastele {

class GlWindow : Window
{
    SDL_GLContext context;
    tvg::GlCanvas* canvas = nullptr;

    public:

    GlWindow(uint32_t width, uint32_t height);
    void initialize();
    virtual ~GlWindow();

    tvg::Canvas* getCanvas();
    void resize();
    bool syncAndUpdateSurface();
};

}

#endif // __GL_WINDOW_H__