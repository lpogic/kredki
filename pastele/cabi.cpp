#include <string>
#include <algorithm>
#include <cmath>
#include <thorvg.h>
#include "cabi.h"
#ifdef THORVG_LOTTIE_LOADER_SUPPORT
#include <thorvg_lottie.h>
#endif

using namespace std;
using namespace tvg;

void fill_set_color_stops_and_spread(Fill* self, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    Fill::ColorStop* stops = new Fill::ColorStop[cnt];
    for(uint32_t i = 0; i < cnt; ++i) {
        stops[i] = { offsets[i], colors[i * 4], colors[i * 4 + 1],  colors[i * 4 + 2],  colors[i * 4 + 3] };
    }
    self->colorStops(stops, cnt);
    self->spread((FillSpread)spread);
    delete [] stops;
}

extern "C" {

CABI void clipboard_set_text(char* text) {
    SDL_SetClipboardText(text);
}

CABI char* clipboard_get_text(void) {
    return SDL_GetClipboardText(); // caller should free it
}

CABI void clipboard_get_mime_types(void(*consumer)(char*)) {
    char** mimeTypes = SDL_GetClipboardMimeTypes(NULL);
    if(!mimeTypes) {
        return;
    }
    for(int i = 0; mimeTypes[i]; ++i) {
        consumer(mimeTypes[i]);
    }
    SDL_free(mimeTypes);
}

CABI uint8_t keyboard_get_key_state(int keycode) {
    auto scancode = SDL_GetScancodeFromKey(keycode, 0); // TODO
    auto state = SDL_GetKeyboardState(nullptr);
    return state[scancode];
}

CABI uint16_t keyboard_get_mod_state(void) {
    return SDL_GetModState();
}

CABI uint32_t mouse_get_button_state(int index) {
    auto buttons_state = SDL_GetMouseState(nullptr, nullptr);
    return buttons_state & SDL_BUTTON_MASK(index);
}

CABI void mouse_get_cursor_position(Point* point) {
    SDL_GetGlobalMouseState(&point->x, &point->y);
}

CABI void mouse_set_capture(int set) {
    SDL_CaptureMouse(set);
}

CABI void* mouse_create_system_cursor(int cursor) {
    return SDL_CreateSystemCursor((SDL_SystemCursor)cursor);
}

CABI void mouse_set_cursor(SDL_Cursor* cursor) {
    SDL_SetCursor(cursor);
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

CABI void* application_new(void) {
    return new pastele::Application;
}

CABI void application_delete(pastele::Application* self) {
    delete self;
}

CABI uint32_t application_insert_window(pastele::Application* self, pastele::Window* window) {
    self->insertWindow(window);
    return SDL_GetWindowID(window->sdl_window);
}

CABI uint32_t application_erase_window(pastele::Application* self, pastele::Window* window) {
    self->eraseWindow(window);
    return SDL_GetWindowID(window->sdl_window);
}

CABI void application_set_event_handler(pastele::Application* self, int(*eventHandler)(int, SDL_Event*)) {
    self->setEventHandler(eventHandler);
}

CABI void application_run(pastele::Application* self) {
    self->run();
}

CABI void application_exit(pastele::Application* self) {
    self->exit();
}

CABI void* window_new_sw(int width, int height) {
    return new pastele::SwWindow(width, height);
}

CABI void* window_new_gl(int width, int height) {
    return new pastele::GlWindow(width, height);
}

CABI void window_delete(pastele::Window* self) {
    self->planDelete();
}

CABI void window_close(pastele::Window* self) {
    self->planClose();
}

CABI void window_update_request(pastele::Window* self) {
    self->updateRequest();
}

CABI void window_update(pastele::Window* self, int needResize) {
    if(needResize) {
        self->setNeedResize();
    }
    self->sync();
}

CABI void window_show(pastele::Window* self) {
    self->show();
}

CABI void window_hide(pastele::Window* self) {
    self->hide();
}

CABI void window_set_scene(pastele::Window* self, tvg::Scene* scene) {
    self->setScene(scene);
}

CABI void window_paint_to_update(pastele::Window* self, tvg::Paint* paint) {
    self->paintToUpdate(paint);
}

CABI void window_maximize(pastele::Window* self) {
    self->maximize();
}

CABI void window_minimize(pastele::Window* self) {
    self->minimize();
}

CABI void window_focus(pastele::Window* self) {
    self->focus();
}

CABI void window_restore(pastele::Window* self) {
    self->restore();
}

CABI void window_set_bordered(pastele::Window* self, int bordered) {
    self->setBordered(bordered);
}

CABI void window_set_fullscreen(pastele::Window* self, int fullscreen) {
    self->setFullscreen(fullscreen);
}

CABI void window_set_mouse_grab(pastele::Window* self, int grab) {
    self->setGrab(grab);
}

CABI int window_get_mouse_grab(pastele::Window* self) {
    return (int) self->getGrab();
}

CABI void window_set_mouse_relative_mode(pastele::Window* self, int set) {
    self->setMouseRelativeMode(set);
}

CABI int window_get_mouse_relative_mode(pastele::Window* self) {
    return (int) self->getMouseRelativeMode();
}

CABI void window_set_minimum_size(pastele::Window* self, int w, int h) {
    self->setMinimumSize(w, h);
}

CABI void window_set_maximum_size(pastele::Window* self, int w, int h) {
    self->setMaximumSize(w, h);
}

CABI void window_get_minimum_size(pastele::Window* self, IntPoint* point) {
    self->getMinimumSize(&point->x, &point->y);
}

CABI void window_get_maximum_size(pastele::Window* self, IntPoint* point) {
    self->getMaximumSize(&point->x, &point->y);
}

CABI void window_set_opacity(pastele::Window* self, float opacity) {
    self->setOpacity(opacity);
}

CABI float window_get_opacity(pastele::Window* self) {
    return self->getOpacity();
}

CABI void window_set_position(pastele::Window* self, int x, int y) {
    self->setPosition(x, y);
}

CABI void window_set_resizable(pastele::Window* self, int resizable) {
    self->setResizable(resizable);
}

CABI void window_set_size(pastele::Window* self, int w, int h) {
    self->setSize(w, h);
}

CABI void window_set_title(pastele::Window* self, char* title) {
    self->setTitle(title);
}

CABI const char* window_get_title(pastele::Window* self) {
    return self->getTitle();
}

CABI void window_set_always_on_top(pastele::Window* self, int on_top) {
    self->setAlwaysOnTop(on_top);
}

CABI void window_get_size(pastele::Window* self, IntPoint* point) {
    self->getSize(&point->x, &point->y);
}

CABI void window_get_position(pastele::Window* self, IntPoint* point) {
    self->getPosition(&point->x, &point->y);
}

CABI void window_set_text_input(pastele::Window* self, int input) {
    self->setTextInput(input);
}

CABI int window_get_text_input(pastele::Window* self) {
    return (int) self->getTextInput();
}

CABI int window_get_flags(pastele::Window* self) {
    return (int) self->getFlags();
}

CABI void window_surface_to_png(pastele::Window* self, const char* file) {
    self->surfaceToPng(file);
}

CABI void window_get_display_bounds(pastele::Window* self, Bounds* bounds) {
    SDL_Rect rect;
    self->getDisplayBounds(&rect);
    bounds->x = (float)rect.x;
    bounds->y = (float)rect.y;
    bounds->w = (float)rect.w;
    bounds->h = (float)rect.h;
}

CABI void window_get_pixel_color(pastele::Window* self, int x, int y, IntPoint* rg, IntPoint* ba) {
    SDL_ReadSurfacePixel(SDL_GetWindowSurface(self->sdl_window), x, y, (uint8_t*)&rg->x, (uint8_t*)&rg->y, (uint8_t*)&ba->x, (uint8_t*)&ba->y);
}

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

CABI uint64_t sdl_get_ticks() {
    return SDL_GetTicksNS();
}

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

CABI void paint_set_transform(Paint* self, float pivot_x, float pivot_y, float x, float y, float a, float zoom_x, float fy) {
    auto m = self->transform();
    auto s = sin(a);
    auto c = cos(a);
    m.e11 = c * zoom_x;
    m.e12 = -s * zoom_x;
    m.e13 = x + pivot_x - m.e11 * pivot_x - m.e12 * pivot_y;
    m.e21 = s * fy;
    m.e22 = c * fy;
    m.e23 = y + pivot_y - m.e21 * pivot_x - m.e22 * pivot_y;
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

CABI void paint_accessor_traverse(Paint* self, int(*callback)(const tvg::Paint* paint, void* data)) {
    auto accessor = Accessor::gen();
    accessor->set(self, callback, nullptr);
}

CABI int paint_get_type(Paint* self) {
    return (int)self->type();
}

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

CABI void shape_append_rect(Shape* self, float x, float y, float w, float h)
{
    self->appendRect(x, y, w, h);
}

CABI void shape_append_circle(Shape* self, float cx, float cy, float rx, float ry)
{
    self->appendCircle(cx, cy, rx, ry);
    self->moveTo(cx, cy);
}

CABI void shape_append_round_rect(Shape* self, float x, float y, float w, float h, float corner_ss, float corner_es, float corner_se, float corner_ee)
{
    #define PATH_KAPPA 0.552284f
    Point pts[18];
    PathCommand cmds[11];

    auto s = Point{w * 0.5f, h * 0.5f};
    auto minr = s.x > s.y ? s.y : s.x;
    corner_ss = (corner_ss > minr) ? minr : corner_ss;
    corner_se = (corner_se > minr) ? minr : corner_se;
    corner_es = (corner_es > minr) ? minr : corner_es;
    corner_ee = (corner_ee > minr) ? minr : corner_ee;
    auto hr = 0.0f;

    cmds[0] = PathCommand::MoveTo;
    pts[0] = {x + w, y + corner_es}; //move
    cmds[1] = PathCommand::LineTo;
    pts[1] = {x + w, y + h - corner_ee}; //line

    auto pi = 2;
    auto ci = 2;
    if(corner_ee > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = corner_ee * PATH_KAPPA;
        pts[pi++] = {x + w, y + h - corner_ee + hr}; 
        pts[pi++] = {x + w - corner_ee + hr, y + h}; 
        pts[pi++] = {x + w - corner_ee, y + h};  //cubic
    }
    cmds[ci++] = PathCommand::LineTo;
    pts[pi++] = {x + corner_se, y + h}; //line
    if(corner_se > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = corner_se * PATH_KAPPA;
        pts[pi++] = {x + corner_se - hr, y + h}; 
        pts[pi++] = {x, y + h - corner_se + hr}; 
        pts[pi++] = {x, y + h - corner_se};  //cubic
    }
    cmds[ci++] = PathCommand::LineTo;
    pts[pi++] = {x, y + corner_ss}; //line
    if(corner_ss > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = corner_ss * PATH_KAPPA;
        pts[pi++] = {x, y + corner_ss - hr}; 
        pts[pi++] = {x + corner_ss - hr, y}; 
        pts[pi++] = {x + corner_ss, y};  //cubic
    }
    cmds[ci++] = PathCommand::LineTo;
    pts[pi++] = {x + w - corner_es, y}; //line
    if(corner_es > 0.0f) {
        cmds[ci++] = PathCommand::CubicTo;
        hr = corner_es * PATH_KAPPA;
        pts[pi++] = {x + w - corner_es + hr, y}; 
        pts[pi++] = {x + w, y + corner_es - hr}; 
        pts[pi++] = {x + w, y + corner_es};  //cubic
    }
    cmds[ci++] = PathCommand::Close;
    cmds[ci++] = PathCommand::MoveTo;
    pts[pi++] = {x, y};

    self->appendPath(&cmds[0], ci, &pts[0], pi);
}

CABI void shape_set_stroke_width(Shape* self, float width)
{
    self->strokeWidth(width);
}

CABI void shape_set_stroke_color(Shape* self, uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    self->strokeFill(r, g, b, a);
}

CABI void shape_set_stroke_linear_gradient(Shape* self, float x, float y, float ex, float ey, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    auto gradient = LinearGradient::gen();
    fill_set_color_stops_and_spread(gradient, colors, offsets, cnt, spread);
    gradient->linear(x, y, ex, ey);
    self->strokeFill(gradient);
}

CABI void shape_set_stroke_radial_gradient(Shape* self, float cx, float cy, float r, float fx, float fy, float fr, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    auto gradient = RadialGradient::gen();
    fill_set_color_stops_and_spread(gradient, colors, offsets, cnt, spread);
    gradient->radial(cx, cy, r, fx, fy, fr);
    self->strokeFill(gradient);
}

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

CABI void shape_set_fill(Shape* self, Fill* fill) {
    self->fill(fill);
}

CABI void shape_set_fill_linear_gradient(Shape* self, float x, float y, float ex, float ey, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    auto gradient = LinearGradient::gen();
    fill_set_color_stops_and_spread(gradient, colors, offsets, cnt, spread);
    gradient->linear(x, y, ex, ey);
    self->fill(gradient);
}

CABI void shape_set_fill_radial_gradient(Shape* self, float cx, float cy, float r, float fx, float fy, float fr, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    auto gradient = RadialGradient::gen();
    fill_set_color_stops_and_spread(gradient, colors, offsets, cnt, spread);
    gradient->radial(cx, cy, r, fx, fy, fr);
    self->fill(gradient);
}

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

CABI void* picture_accessor_get(Picture* self, const char* id) {
    return (void*)self->paint(tvg::Accessor::id(id));
}

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

CABI void scene_add(Scene* self, Paint* paint, Paint* at) {
    self->add(paint, at);
}

CABI void scene_remove(Scene* self, Paint* paint) {
    self->remove(paint);
}

CABI void scene_clear_effects(Scene* self) {
    self->add(SceneEffect::Clear);
}

CABI void scene_add_gaussian_blur(Scene* self, double sigma, int direction, int border, int quality) {
    self->add(SceneEffect::GaussianBlur, sigma, direction, border, quality);
}

CABI void scene_add_drop_shadow(Scene* self, int r, int g, int b, int a, double angle, double distance, double blurSigma, int quality) {
    self->add(SceneEffect::DropShadow, r, g, b, a, angle, distance, blurSigma, quality);
}

CABI void scene_add_fill(Scene* self, int r, int g, int b, int a) {
    self->add(SceneEffect::Fill, r, g, b, a);
}

CABI void scene_add_tint(Scene* self, int br, int bg, int bb, int wr, int wg, int wb, double intensity) {
    self->add(SceneEffect::Tint, br, bg, bb, wr, wg, wb, intensity);
}

CABI void scene_add_tritone(Scene* self, int sr, int sg, int sb, int mr, int mg, int mb, int hr, int hg, int hb, int blend) {
    self->add(SceneEffect::Tint, sr, sg, sb, mr, mg, mb, hr, hg, hb, blend);
}

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

CABI void text_set_font(Text* self, const char* fontName) {
    self->font(fontName);
}

CABI void text_set_size(Text* self, float size) {
    self->size(size);
}

CABI void text_set_text(Text* self, const char* text) {
    self->text(text);
}

CABI void text_set_fill_color(Text* self, uint8_t r, uint8_t g, uint8_t b) {
    self->fill(r, g, b);
}

CABI void text_set_fill_linear_gradient(Text* self, float x, float y, float ex, float ey, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    auto gradient = LinearGradient::gen();
    fill_set_color_stops_and_spread(gradient, colors, offsets, cnt, spread);
    gradient->linear(x, y, ex, ey);
    self->fill(gradient);
}

CABI void text_set_fill_radial_gradient(Text* self, float cx, float cy, float r, float fx, float fy, float fr, const uint8_t* colors, const float* offsets, uint32_t cnt, int spread) {
    auto gradient = RadialGradient::gen();
    fill_set_color_stops_and_spread(gradient, colors, offsets, cnt, spread);
    gradient->radial(cx, cy, r, fx, fy, fr);
    self->fill(gradient);
}

CABI void text_set_outline(Text* self, float width, uint8_t r, uint8_t g, uint8_t b) {
    self->outline(width, r, g, b);
}

CABI float text_get_text_width(Text* self, const char* text, int indexLimit) {
    float width;
    self->measure(text, 1, -1, indexLimit, &width, nullptr);
    return width;
}

CABI int text_nearest_character_index(Text* self, const char* text, float widthLimit) {
    int index;
    self->measure(text, 2, widthLimit, -1, nullptr, &index);
    return index;
}

CABI int font_load(const char* path)
{
    return (int) Text::load(path);
}

CABI int font_unload(const char* path)
{
    return (int) Text::unload(path);
}

CABI Animation* animation_new(void) {
    return Animation::gen();
}

CABI void animation_set_frame(Animation* self, float no) {
    self->frame(no);
}

CABI Paint* animation_get_picture(Animation* self) {
    return self->picture();
}

CABI float animation_get_total_frames(Animation* self) {
    return self->totalFrame();
}

CABI float animation_get_duration(Animation* self) {
    return self->duration();
}

CABI void animation_set_segment(Animation* self, float begin, float end) {
    self->segment(begin, end);
}

CABI void animation_delete(Animation* self) {
    union SDL_Event event;
    event.type = USEREVENT_DELETEANIMATION;
    SDL_UserEvent userEvent;
    userEvent.type = USEREVENT_DELETEANIMATION;
    userEvent.data1 = self;
    event.user = userEvent;
    SDL_PushEvent(&event);
}


}