#ifndef __WINDOW_H__
#define __WINDOW_H__

#include <set>
#include <iostream>
#include <thorvg.h>
#include <SDL.h>
#ifdef _WIN32
    #include <windows.h>
    #ifndef PATH_MAX
        #define PATH_MAX MAX_PATH
    #endif
#else
    #include <dirent.h>
    #include <unistd.h>
    #include <limits.h>
    #include <sys/stat.h>
#endif

#ifdef THORVG_WG_RASTER_SUPPORT
    #include <webgpu/webgpu.h>
    #if defined(SDL_VIDEO_DRIVER_COCOA)
        #include <Cocoa/Cocoa.h>
        #include <QuartzCore/CAMetalLayer.h>
    #endif
#endif

#define USEREVENT_DELETEWINDOW (SDL_EVENT_USER + 0)
#define USEREVENT_UPDATEWINDOW (SDL_EVENT_USER + 1)

using namespace std;

namespace pastele {

class Window
{
    protected:

    set<tvg::Paint*> toUpdate;
    bool needResize = false;
    bool needDraw = true;
    bool needSync = false;

    public:

    SDL_Window* sdl_window = nullptr;

    bool verify(tvg::Result result)
    {
        switch (result) {
            case tvg::Result::FailedAllocation:
                cout << "FailedAllocation!" << endl;
                return false;
            case tvg::Result::InsufficientCondition:
                cout << "InsufficientCondition!" << endl;
                return false;
            case tvg::Result::InvalidArguments:
                cout << "InvalidArguments!" << endl;
                return false;
            case tvg::Result::MemoryCorruption:
                cout << "MemoryCorruption!" << endl;
                return false;
            case tvg::Result::NonSupport:
                cout << "NonSupport!" << endl;
                return false;
            case tvg::Result::Unknown:
                cout << "Unknown!" << endl;
                return false;
            default:
                return true;
        }
    }

    void setScene(tvg::Scene* scene);
    void sync(void);
    bool update(tvg::Canvas* canvas);
    bool paintDelete(tvg::Paint* paint);
    void planDelete(void);
    void planUpdate(void);
    void setNeedResize();
    void paintToUpdate(tvg::Paint* paint);
    void maximize(void);
    void minimize(void);
    void focus();
    void restore(void);
    void setBordered(bool bordered);
    void setFullscreen(bool fullscreen);
    void setGrab(bool grab);
    bool getGrab(void);
    void setMouseRelativeMode(bool relative);
    bool getMouseRelativeMode(void);
    void setMinimumSize(int w, int h);
    void setMaximumSize(int w, int h);
    void getMinimumSize(int* w, int* h);
    void getMaximumSize(int* w, int* h);
    void setOpacity(float opacity);
    float getOpacity();
    void setPosition(int x, int y);
    void setResizable(bool resizable);
    void setSize(int w, int h);
    void setTitle(char* title);
    const char* getTitle();
    void setAlwaysOnTop(bool on_top);
    void getSize(int* x, int* y);
    void getPosition(int* x, int* y);
    void setTextInput(bool text_input);
    bool getTextInput();
    int getFlags();
    void surfaceToPng(const char* file);
    void show(void);
    void hide(void);

    virtual tvg::Canvas* getCanvas() { return nullptr; }
    virtual void resize() {}
    virtual bool syncAndUpdateSurface() { return false; }
};

}

#endif // __WINDOW_H__