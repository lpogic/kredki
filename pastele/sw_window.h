#ifndef __SW_WINDOW_H__
#define __SW_WINDOW_H__

#include "window.h"

namespace pastele {

class SwWindow : Window
{
    tvg::SwCanvas* canvas = nullptr;

    public:

    SwWindow(uint32_t width, uint32_t height);
    virtual ~SwWindow();
    void initialize();

    tvg::Canvas* getCanvas();
    void resize();
    bool syncAndUpdateSurface();
};

}

#endif // __SW_WINDOW_H__