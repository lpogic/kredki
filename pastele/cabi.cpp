#include <string>
#include <algorithm>
#include <thorvg.h>
#include "cabi.h"
#ifdef THORVG_LOTTIE_LOADER_SUPPORT
#include <thorvg_lottie.h>
#endif

using namespace std;
using namespace tvg;

extern "C" {


CABI void clipboard_set_text(char* text) {
    SDL_SetClipboardText(text);
}

CABI char* clipboard_get_text(void) {
    return SDL_GetClipboardText(); // caller should free it
}

CABI uint8_t keyboard_get_key_state(int keycode) {
    auto scancode = SDL_GetScancodeFromKey(keycode, 0); // TODO
    auto state = SDL_GetKeyboardState(nullptr);
    return state[scancode];
}

CABI uint16_t keyboard_get_shift_state(void) {
    return SDL_GetModState() & SDL_KMOD_SHIFT;
}

CABI uint16_t keyboard_get_ctrl_state(void) {
    return SDL_GetModState() & SDL_KMOD_CTRL;
}

CABI uint16_t keyboard_get_alt_state(void) {
    return SDL_GetModState() & SDL_KMOD_ALT;
}

CABI uint16_t keyboard_get_num_state(void) {
    return SDL_GetModState() & SDL_KMOD_NUM;
}

CABI uint16_t keyboard_get_caps_state(void) {
    return SDL_GetModState() & SDL_KMOD_CAPS;
}

CABI uint16_t keyboard_get_scroll_state(void) {
    return SDL_GetModState() & SDL_KMOD_SCROLL;
}

CABI uint32_t mouse_get_button_state(int index) {
    auto buttons_state = SDL_GetMouseState(nullptr, nullptr);
    return buttons_state & SDL_BUTTON_MASK(index);
}

CABI void mouse_get_cursor_position(Point* point) {
    SDL_GetGlobalMouseState(&point->x, &point->y);
}

CABI void mouse_set_relative_mode(int set) {
    // SDL_SetWindowRelativeMouseMode(set); TODO
}

CABI void mouse_set_capture(int set) {
    SDL_CaptureMouse(set);
}

CABI uint32_t joystick_open(int index) {
    auto sdl_joystick = SDL_OpenJoystick(index);
    return SDL_GetJoystickID(sdl_joystick);
}

CABI uint8_t joystick_get_button_state(int device_id, int button_index) {
    return SDL_GetJoystickButton(SDL_GetJoystickFromID(device_id), button_index);
}

CABI int16_t joystick_get_axis_value(int device_id, int axis_index) {
    return SDL_GetJoystickAxis(SDL_GetJoystickFromID(device_id), axis_index);
}

CABI void* arena_new(void) {
    return new pas::Arena;
}

CABI void arena_delete(pas::Arena* self) {
    delete self;
}

CABI uint32_t arena_insert_window(pas::Arena* self, pas::Window* window) {
    self->insertWindow(window);
    return SDL_GetWindowID(window->sdl_window);
}

CABI uint32_t arena_erase_window(pas::Arena* self, pas::Window* window) {
    self->eraseWindow(window);
    return SDL_GetWindowID(window->sdl_window);
}

CABI void arena_set_event_handler(pas::Arena* self, int(*eventHandler)(int, SDL_Event*)) {
    self->setEventHandler(eventHandler);
}

CABI void arena_run(pas::Arena* self) {
    self->run();
}

CABI void arena_terminate(pas::Arena* self) {
    self->terminate();
}


CABI void* window_new(int width, int height) {
    // tvg::CanvasEngine engine = tvg::CanvasEngine::Sw;
    // switch(engine) {
    //     case tvg::CanvasEngine::Gl:
    //         return new pas::GlWindow(width, height);
    //     case tvg::CanvasEngine::Wg:
    //         return new pas::WgWindow(width, height);
    //     case tvg::CanvasEngine::Sw:
    //     default:
    //         return new pas::SwWindow(width, height);
    // }
    return new pas::SwWindow(width, height);
}

CABI void window_delete(pas::Window* self) {
    self->planDelete();
}

CABI void window_update(pas::Window* self) {
    self->planUpdate();
}

CABI void window_set_scene(pas::Window* self, tvg::Scene* scene) {
    self->setScene(scene);
}

CABI void window_set_step_handler(pas::Window* self, void(*stepHandler)(int)) {
    self->setStepHandler(stepHandler);
}

CABI void window_paint_to_update(pas::Window* self, tvg::Paint* paint) {
    self->paintToUpdate(paint);
}

CABI void window_maximize(pas::Window* self) {
    self->maximize();
}

CABI void window_minimize(pas::Window* self) {
    self->minimize();
}

CABI void window_focus(pas::Window* self) {
    self->focus();
}

CABI void window_restore(pas::Window* self) {
    self->restore();
}

CABI void window_set_bordered(pas::Window* self, int bordered) {
    self->setBordered(bordered);
}

CABI void window_set_fullscreen(pas::Window* self, int fullscreen) {
    self->setFullscreen(fullscreen);
}

CABI void window_set_grab(pas::Window* self, int grab) {
    self->setGrab(grab);
}

CABI void window_set_maximum_size(pas::Window* self, int w, int h) {
    self->setMaximumSize(w, h);
}

CABI void window_set_minimum_size(pas::Window* self, int w, int h) {
    self->setMinimumSize(w, h);
}

CABI void window_set_opacity(pas::Window* self, float opacity) {
    self->setOpacity(opacity);
}

CABI void window_set_position(pas::Window* self, int x, int y) {
    self->setPosition(x, y);
}

CABI void window_set_resizable(pas::Window* self, int resizable) {
    self->setResizable(resizable);
}

CABI void window_set_size(pas::Window* self, int w, int h) {
    self->setSize(w, h);
}

CABI void window_set_title(pas::Window* self, char* title) {
    self->setTitle(title);
}

CABI void window_set_always_on_top(pas::Window* self, int on_top) {
    self->setAlwaysOnTop(on_top);
}

CABI void window_get_size(pas::Window* self, IntPoint* point) {
    self->getSize(&point->x, &point->y);
}

CABI void window_get_position(pas::Window* self, IntPoint* point) {
    self->getPosition(&point->x, &point->y);
}

CABI void window_set_text_input(pas::Window* self, int input) {
    self->setTextInput(input);
}

CABI int window_get_text_input(pas::Window* self) {
    return (int) self->getTextInput();
}

CABI int window_get_flags(pas::Window* self) {
    return (int) SDL_GetWindowFlags(self->sdl_window);
}

/************************************************************************/
/* Engine API                                                           */
/************************************************************************/

CABI int thorvg_engine_init(int engine_method, int threads)
{
    // return (int) Initializer::init(threads, CanvasEngine(engine_method));
    return (int) Initializer::init(threads);
}


CABI int thorvg_engine_term(int engine_method)
{
    // return (int) Initializer::term(CanvasEngine(engine_method));
    return (int) Initializer::term();
}

CABI void sdl_init(int joystick_enabled) {
    auto flags = SDL_INIT_VIDEO;
    if(joystick_enabled) {
        flags |= SDL_INIT_JOYSTICK;
    }
    SDL_Init(flags);
    if(joystick_enabled) {
        SDL_SetJoystickEventsEnabled(true);
    }
    SDL_GL_SetSwapInterval(1);
    SDL_RegisterEvents(USEREVENT_S_COUNT);
}

CABI int sdl_get_ticks() {
    return (int)SDL_GetTicks();
}

// /************************************************************************/
// /* Paint API                                                            */
// /************************************************************************/

CABI void paint_delete(Paint* self)
{
    union SDL_Event event;
    event.type = USEREVENT_DELETEPAINT;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETEPAINT;
    userEvent.data1 = self;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

CABI void paint_set_transform(Paint* self, float pivot_x, float pivot_y, float x, float y, float a, float scale_x, float scale_y) {
    auto m = self->transform();
    auto s = sinf(a);
    auto c = cosf(a);
    m.e11 = c * scale_x;
    m.e12 = -s * scale_x;
    m.e13 = x + pivot_x - c * scale_x * pivot_x + s * scale_x * pivot_y;
    m.e21 = s * scale_y;
    m.e22 = c * scale_y;
    m.e23 = y + pivot_y - s * scale_y * pivot_x - c * scale_y * pivot_y;
    self->transform(m);
}

CABI void paint_set_opacity(Paint* self, uint8_t opacity) {
    self->opacity(opacity);
}

CABI int paint_get_opacity(Paint* self) {
    return self->opacity();
}

CABI void paint_get_bounds(Paint* self, Bounds* bounds) {
    self->bounds(&bounds->x, &bounds->y, &bounds->w, &bounds->h);
}

CABI void paint_set_clip(Paint* self, Shape* clipper) {
    self->clip(clipper);
}

CABI void paint_set_mask(Paint* self, Paint* target, int mask) {
    self->mask(target, (MaskMethod)mask);
}

CABI void paint_set_blend_method(Paint* self, int method) {
    self->blend((BlendMethod)method);
}


/************************************************************************/
/* Shape API                                                            */
/************************************************************************/

CABI void* shape_new()
{
    auto self = Shape::gen();
    self->ref();
    return self;
}

CABI void shape_delete(Shape* self) {
    union SDL_Event event;
    event.type = USEREVENT_DELETESHAPE;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETESHAPE;
    userEvent.data1 = self;
    event.user = userEvent;
    SDL_PushEvent(&event);
}


CABI void shape_reset(Shape* self)
{
    self->reset();
}


CABI void shape_move_to(Shape* self, float x, float y)
{
    self->moveTo(x, y);
}


CABI void shape_line_to(Shape* self, float x, float y)
{
    self->lineTo(x, y);
}


CABI void shape_cubic_to(Shape* self, float cx1, float cy1, float cx2, float cy2, float x, float y)
{
    self->cubicTo(cx1, cy1, cx2, cy2, x, y);
}


CABI void shape_close(Shape* self)
{
    self->close();
}

CABI void shape_append_rect(Shape* self, float x, float y, float w, float h, float rx, float ry)
{
    self->appendRect(x, y, w, h, rx, ry);
}

CABI void shape_append_rect1(Shape* self, float x, float y, float w, float h, float rbb, float reb, float rbe, float ree)
{
    #define PATH_KAPPA 0.552284f
    Point pts[18];
    PathCommand cmds[11];

    auto s = Point{w * 0.5f, h * 0.5f};
    auto minr = s.x > s.y ? s.y : s.x;
    rbb = (rbb > minr) ? minr : rbb;
    rbe = (rbe > minr) ? minr : rbe;
    reb = (reb > minr) ? minr : reb;
    ree = (ree > minr) ? minr : ree;
    auto hr = 0.0f;

    cmds[0] = PathCommand::MoveTo;
    pts[0] = {x + w, y + reb}; //move
    cmds[1] = PathCommand::LineTo;
    pts[1] = {x + w, y + h - ree}; //line

    auto pi = 2;
    auto ci = 2;
    if(ree > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = ree * PATH_KAPPA;
        pts[pi++] = {x + w, y + h - ree + hr}; 
        pts[pi++] = {x + w - ree + hr, y + h}; 
        pts[pi++] = {x + w - ree, y + h};  //cubic
    }
    cmds[ci++] = PathCommand::LineTo;
    pts[pi++] = {x + rbe, y + h}; //line
    if(rbe > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = rbe * PATH_KAPPA;
        pts[pi++] = {x + rbe - hr, y + h}; 
        pts[pi++] = {x, y + h - rbe + hr}; 
        pts[pi++] = {x, y + h - rbe};  //cubic
    }
    cmds[ci++] = PathCommand::LineTo;
    pts[pi++] = {x, y + rbb}; //line
    if(rbb > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = rbb * PATH_KAPPA;
        pts[pi++] = {x, y + rbb - hr}; 
        pts[pi++] = {x + rbb - hr, y}; 
        pts[pi++] = {x + rbb, y};  //cubic
    }
    cmds[ci++] = PathCommand::LineTo;
    pts[pi++] = {x + w - reb, y}; //line
    if(reb > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = reb * PATH_KAPPA;
        pts[pi++] = {x + w - reb + hr, y}; 
        pts[pi++] = {x + w, y + reb - hr}; 
        pts[pi++] = {x + w, y + reb};  //cubic
    }
    cmds[ci++] = PathCommand::Close;
    cmds[ci++] = PathCommand::MoveTo;
    pts[pi++] = {x, y};

    self->appendPath(&cmds[0], ci, &pts[0], pi);
}

CABI void shape_append_circle(Shape* self, float cx, float cy, float rx, float ry)
{
    self->appendCircle(cx, cy, rx, ry);
    self->moveTo(cx, cy);
}

CABI void shape_set_stroke_width(Shape* self, float width)
{
    self->strokeWidth(width);
}

CABI void shape_set_stroke_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    self->strokeFill(r, g, b, a);
}

// CABI int tvg_shape_set_stroke_linear_gradient(Shape* self, Tvg_Gradient* gradient)
// {
//     if (!self) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) self->strokeFill(unique_ptr<LinearGradient>((LinearGradient*)(gradient)));
// }


// CABI int tvg_shape_set_stroke_radial_gradient(Shape* self, Tvg_Gradient* gradient)
// {
//     if (!self) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) self->strokeFill(unique_ptr<RadialGradient>((RadialGradient*)(gradient)));
// }


// CABI int tvg_shape_get_stroke_gradient(const Shape* self, Tvg_Gradient** gradient)
// {
//    if (!self || !gradient) return TVG_RESULT_INVALID_ARGUMENT;
//    *gradient = (Tvg_Gradient*)(reinterpret_cast<const Shape*>(self)->strokeFill());
//    return TVG_RESULT_SUCCESS;
// }

CABI void shape_set_stroke_dash(Shape* self, const float* dashPattern, uint32_t cnt, float offset) {
    self->strokeDash(dashPattern, cnt);
}

CABI void shape_set_stroke_cap(Shape* self, int cap)
{
    self->strokeCap((StrokeCap)cap);
}

CABI void shape_set_stroke_join(Shape* self, int join)
{
    self->strokeJoin((StrokeJoin)join);
}

CABI void shape_set_stroke_miterlimit(Shape* self, float ml)
{
    self->strokeMiterlimit(ml);
}

CABI void shape_set_stroke_trim(Shape* self, float begin, float end, int simultaneous) {
    self->trimpath(begin, end, simultaneous);
}

CABI void shape_set_fill_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    self->fill(r, g, b, a);
}

CABI void shape_set_fill_rule(Shape* self, int rule) {
    self->fillRule((FillRule)rule);
}

CABI void shape_set_paint_order(Shape* self, int strokeFirst) {
    self->order(strokeFirst);
}

// CABI int tvg_shape_set_linear_gradient(Tvg_Paint* paint, Tvg_Gradient* gradient)
// {
//     if (!paint) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Shape*>(paint)->fill(unique_ptr<LinearGradient>((LinearGradient*)(gradient)));
// }


// CABI int tvg_shape_set_radial_gradient(Tvg_Paint* paint, Tvg_Gradient* gradient)
// {
//     if (!paint) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Shape*>(paint)->fill(unique_ptr<RadialGradient>((RadialGradient*)(gradient)));
// }


// CABI int tvg_shape_get_gradient(const Tvg_Paint* paint, Tvg_Gradient** gradient)
// {
//    if (!paint || !gradient) return TVG_RESULT_INVALID_ARGUMENT;
//    *gradient = (Tvg_Gradient*)(reinterpret_cast<const Shape*>(paint)->fill());
//    return TVG_RESULT_SUCCESS;
// }

// /************************************************************************/
// /* Picture API                                                          */
// /************************************************************************/

CABI Picture* picture_new(void) {
    auto self = Picture::gen();
    self->ref();
    return self;
}

CABI int picture_load(Picture* self, const char* path) {
    return (int) self->load(path);
}

// CABI int picture_load_raw(Picture* self, uint32_t *data, uint32_t w, uint32_t h, bool premultiplied, bool copy);
// CABI int picture_load_data(Picture* self, const char *data, uint32_t size, const char *mimetype, const char* rpath, bool copy);

CABI void picture_set_size(Picture* self, float w, float h) {
    self->size(w, h);
}

CABI void picture_get_size(Picture* self, Point* size) {
    self->size(&size->x, &size->y);
}


// /************************************************************************/
// /* Gradient API                                                         */
// /************************************************************************/

// CABI Tvg_Gradient* tvg_linear_gradient_new()
// {
//     return (Tvg_Gradient*)LinearGradient::gen().release();
// }


// CABI Tvg_Gradient* tvg_radial_gradient_new()
// {
//     return (Tvg_Gradient*)RadialGradient::gen().release();
// }


// CABI Tvg_Gradient* tvg_gradient_duplicate(Tvg_Gradient* grad)
// {
//     if (!grad) return nullptr;
//     return (Tvg_Gradient*) reinterpret_cast<Fill*>(grad)->duplicate();
// }


// CABI int tvg_gradient_del(Tvg_Gradient* grad)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     delete(reinterpret_cast<Fill*>(grad));
//     return TVG_RESULT_SUCCESS;
// }


// CABI int tvg_linear_gradient_set(Tvg_Gradient* grad, float x1, float y1, float x2, float y2)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<LinearGradient*>(grad)->linear(x1, y1, x2, y2);
// }


// CABI int tvg_linear_gradient_get(Tvg_Gradient* grad, float* x1, float* y1, float* x2, float* y2)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<LinearGradient*>(grad)->linear(x1, y1, x2, y2);
// }


// CABI int tvg_radial_gradient_set(Tvg_Gradient* grad, float cx, float cy, float radius)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<RadialGradient*>(grad)->radial(cx, cy, radius);
// }


// CABI int tvg_radial_gradient_get(Tvg_Gradient* grad, float* cx, float* cy, float* radius)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<RadialGradient*>(grad)->radial(cx, cy, radius);
// }


// CABI int tvg_gradient_set_color_stops(Tvg_Gradient* grad, const Tvg_Color_Stop* color_stop, uint32_t cnt)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Fill*>(grad)->colorStops(reinterpret_cast<const Fill::ColorStop*>(color_stop), cnt);
// }


// CABI int tvg_gradient_get_color_stops(const Tvg_Gradient* grad, const Tvg_Color_Stop** color_stop, uint32_t* cnt)
// {
//     if (!grad || !color_stop || !cnt) return TVG_RESULT_INVALID_ARGUMENT;
//     *cnt = reinterpret_cast<const Fill*>(grad)->colorStops(reinterpret_cast<const Fill::ColorStop**>(color_stop));
//     return TVG_RESULT_SUCCESS;
// }


// CABI int tvg_gradient_set_spread(Tvg_Gradient* grad, const Tvg_Stroke_Fill spread)
// {
//     if (!grad) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Fill*>(grad)->spread((FillSpread)spread);
// }


// CABI int tvg_gradient_get_spread(const Tvg_Gradient* grad, Tvg_Stroke_Fill* spread)
// {
//     if (!grad || !spread) return TVG_RESULT_INVALID_ARGUMENT;
//     *spread = (Tvg_Stroke_Fill) reinterpret_cast<const Fill*>(grad)->spread();
//     return TVG_RESULT_SUCCESS;
// }


// CABI int tvg_gradient_set_transform(Tvg_Gradient* grad, const Tvg_Matrix* m)
// {
//     if (!grad || !m) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Fill*>(grad)->transform(*(reinterpret_cast<const Matrix*>(m)));
// }


// CABI int tvg_gradient_get_transform(const Tvg_Gradient* grad, Tvg_Matrix* m)
// {
//     if (!grad || !m) return TVG_RESULT_INVALID_ARGUMENT;
//     *reinterpret_cast<Matrix*>(m) = reinterpret_cast<Fill*>(const_cast<Tvg_Gradient*>(grad))->transform();
//     return TVG_RESULT_SUCCESS;
// }


// CABI int tvg_gradient_get_identifier(const Tvg_Gradient* grad, Tvg_Identifier* identifier)
// {
//     if (!grad || !identifier) return TVG_RESULT_INVALID_ARGUMENT;
//     *identifier = static_cast<Tvg_Identifier>(reinterpret_cast<const Fill*>(grad)->identifier());
//     return TVG_RESULT_SUCCESS;
// }

/************************************************************************/
/* Scene API                                                            */
/************************************************************************/

CABI void* scene_new()
{
    auto self = Scene::gen();
    self->ref();
    return self;
}

CABI void scene_delete(Scene* self) {
    union SDL_Event event;
    event.type = USEREVENT_DELETESCENE;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETESCENE;
    userEvent.data1 = self;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

CABI void scene_push(Scene* self, Paint* paint, Paint* at) {
    self->push(paint, at);
}

CABI void scene_remove(Scene* self, Paint* paint) {
    self->remove(paint);
}

// /************************************************************************/
// /* Text API                                                            */
// /************************************************************************/

CABI void* text_new(void) {
    auto self = Text::gen();
    self->ref();
    return self;
}

CABI void text_delete(Text* self) {
    union SDL_Event event;
    event.type = USEREVENT_DELETETEXT;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETETEXT;
    userEvent.data1 = self;
    event.user = userEvent;
    SDL_PushEvent(&event);
}

CABI void text_set_font(Text* self, const char* name, float size, const char* style) {
    self->font(name, size, style);
}

CABI void text_set_text(Text* self, const char* text) {
    self->text(text);
}

CABI float text_get_text_width(Text* self, const char* text, int indexLimit) {
    float width;
    self->textMetrics(text, 1, -1, indexLimit, &width, nullptr);
    return width;
}

CABI int text_nearest_character_index(Text* self, const char* text, float widthRequest) {
    int index;
    self->textMetrics(text, 2, widthRequest, -1, nullptr, &index);
    return index;
}

CABI void text_set_fill_color(Text* self, uint8_t r, uint8_t g, uint8_t b) {
    self->fill(r, g, b);
}


// CABI int tvg_text_set_linear_gradient(Tvg_Paint* paint, Tvg_Gradient* gradient)
// {
//     if (!paint) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Text*>(paint)->fill(unique_ptr<LinearGradient>((LinearGradient*)(gradient)));
// }


// CABI int tvg_text_set_radial_gradient(Tvg_Paint* paint, Tvg_Gradient* gradient)
// {
//     if (!paint) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Text*>(paint)->fill(unique_ptr<RadialGradient>((RadialGradient*)(gradient)));
// }


CABI int font_load(const char* path)
{
    return (int) Text::load(path);
}

CABI int font_unload(const char* path)
{
    return (int) Text::unload(path);
}


// /************************************************************************/
// /* Saver API                                                            */
// /************************************************************************/

// CABI Tvg_Saver* tvg_saver_new()
// {
//     return (Tvg_Saver*) Saver::gen().release();
// }


// CABI int tvg_saver_save(Tvg_Saver* saver, Tvg_Paint* paint, const char* path, uint32_t quality)
// {
//     if (!saver || !paint || !path) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Saver*>(saver)->save(unique_ptr<Paint>((Paint*)paint), path, quality);
// }


// CABI int tvg_saver_sync(Tvg_Saver* saver)
// {
//     if (!saver) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Saver*>(saver)->sync();
// }


// CABI int tvg_saver_del(Tvg_Saver* saver)
// {
//     if (!saver) return TVG_RESULT_INVALID_ARGUMENT;
//     delete(reinterpret_cast<Saver*>(saver));
//     return TVG_RESULT_SUCCESS;
// }


// /************************************************************************/
// /* Animation API                                                        */
// /************************************************************************/

CABI Animation* animation_new(void) {
    return Animation::gen();
}

CABI void animation_set_frame(Animation* self, float no) {
    self->frame(no);
}

CABI Paint* animation_get_picture(Animation* self) {
    return self->picture();
}

// CABI int tvg_animation_get_frame(Tvg_Animation* animation, float* no)
// {
//     if (!animation || !no) return TVG_RESULT_INVALID_ARGUMENT;
//     *no = reinterpret_cast<Animation*>(animation)->curFrame();
//     return TVG_RESULT_SUCCESS;
// }

CABI float animation_get_total_frame(Animation* self) {
    return self->totalFrame();
}

CABI float animation_get_duration(Animation* self) {
    return self->duration();
}

CABI void animation_set_segment(Animation* self, float begin, float end) {
    self->segment(begin, end);
}

// CABI int tvg_animation_get_segment(Tvg_Animation* animation, float* start, float* end)
// {
//     if (!animation) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<Animation*>(animation)->segment(start, end);
// }

CABI void animation_delete(Animation* self) {
    union SDL_Event event;
    event.type = USEREVENT_DELETEANIMATION;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETEANIMATION;
    userEvent.data1 = self;
    event.user = userEvent;
    SDL_PushEvent(&event);
}


// /************************************************************************/
// /* Lottie Animation API                                                 */
// /************************************************************************/

// CABI Tvg_Animation* tvg_lottie_animation_new()
// {
// #ifdef THORVG_LOTTIE_LOADER_SUPPORT
//     return (Tvg_Animation*) LottieAnimation::gen().release();
// #endif
//     return nullptr;
// }


// CABI int tvg_lottie_animation_override(Tvg_Animation* animation, const char* slot)
// {
// #ifdef THORVG_LOTTIE_LOADER_SUPPORT
//     if (!animation) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<LottieAnimation*>(animation)->override(slot);
// #endif
//     return TVG_RESULT_NOT_SUPPORTED;
// }


// CABI int tvg_lottie_animation_set_marker(Tvg_Animation* animation, const char* marker)
// {
// #ifdef THORVG_LOTTIE_LOADER_SUPPORT
//     if (!animation) return TVG_RESULT_INVALID_ARGUMENT;
//     return (int) reinterpret_cast<LottieAnimation*>(animation)->segment(marker);
// #endif
//     return TVG_RESULT_NOT_SUPPORTED;
// }


// CABI int tvg_lottie_animation_get_markers_cnt(Tvg_Animation* animation, uint32_t* cnt)
// {
// #ifdef THORVG_LOTTIE_LOADER_SUPPORT
//     if (!animation || !cnt) return TVG_RESULT_INVALID_ARGUMENT;
//     *cnt = reinterpret_cast<LottieAnimation*>(animation)->markersCnt();
//     return TVG_RESULT_SUCCESS;
// #endif
//     return TVG_RESULT_NOT_SUPPORTED;
// }


// CABI int tvg_lottie_animation_get_marker(Tvg_Animation* animation, uint32_t idx, const char** name)
// {
// #ifdef THORVG_LOTTIE_LOADER_SUPPORT
//     if (!animation || !name) return TVG_RESULT_INVALID_ARGUMENT;
//     *name = reinterpret_cast<LottieAnimation*>(animation)->marker(idx);
//     if (!(*name)) return TVG_RESULT_INVALID_ARGUMENT;
//     return TVG_RESULT_SUCCESS;
// #endif
//     return TVG_RESULT_NOT_SUPPORTED;
// }

}