require 'kredki'

plugin! :mouse_in_scale do
  on_mouse_enter! do
    play! :mouse_in_scale do |job|
      if job.total_ms > 500
        stop! :mouse_in_scale
      else
        mag! 1 + Util.sin01(job.total_ms, 1000) / 4000
      end
    end
  end

  on_mouse_leave! do
    play! :mouse_in_scale do |job|
      if job.total_ms > 500
        stop! :mouse_in_scale
        mag! 1
      else
        mag! 1 + Util.sin01(1000 + job.total_ms, 1000) / 4000
      end
    end
  end
end

layout! :xcc
mi! 10

button! :mouse_in_scale
button! "Hello", :mouse_in_scale
button! :mouse_in_scale, fill: :green
