module Kredki
  # Base class for all graphical objects.
  class Paint

    # Set position along the X axis.
    def x! x = @x
      return x! yield @x if block_given?
      return if @x == x
      @x = x
      update_transform
      update
    end
    
    # See #x!.
    def x= param
      send_ahp :x!, param
    end

    # Get position along the X axis.
    def x
      @x
    end

    # Set position along the Y axis.
    def y! y = @y
      return y! yield @y if block_given?
      return if @y == y
      @y = y
      update_transform
      update
    end

    # See #y!.
    def y= param
      send_ahp :y!, param
    end

    # Get position along the X axis.
    def y
      @y
    end

    # Set position along X and Y axes.
    def xy! x = @x, y = x
      return send_ahp :xy!, yield(self.xy) if block_given?
      return if @x == x && @y == y
      @x = x
      @y = y
      update_transform
      update
    end
    
    # See #xy!.
    def xy= param
      send_ahp :xy!, param
    end

    # Get position along X and Y axes.
    def xy
      [@x, @y]
    end
 
    # Set rotation angle around the pivot point.
    def rot! rot = @rot
      return rot! yield @rot if block_given?
      return if @rot == rot
      @rot = rot
      update_transform
      update
    end

    # See #rot!.
    def rot= param
      send_ahp :rot!, param
    end

    # Get rotation angle around the pivot point.
    def rot
      @rot
    end

    # Set magnification factor along the X axis.
    def mag_x! mag_x = @mag_x
      return mag_x! yield @mag_x if block_given?
      return if @mag_x == mag_x
      @mag_x = mag_x
      update_transform
      update
    end

    # See #mag_x!.
    def mag_x= param
      send_ahp :mag_x!, param
    end

    # Get magnification factor along the X axis.
    def mag_x
      @mag_x
    end

    # Set magnification factor along the Y axis.
    def mag_y! mag_y = @mag_y
      return mag_y! yield @mag_y if block_given?
      return if @mag_y == mag_y
      @mag_y = mag_y
      update_transform
      update
    end

    # See #mag_y!.
    def mag_y= param
      send_ahp :mag_y!, param
    end

    # Get magnification factor along the Y axis.
    def mag_y
      @mag_y
    end

    # Set magnification factor along X and Y axes.
    def mag! mag_x = @mag_x, mag_y = mag_x, **na
      return send_ahp :mag!, yield(self.mag) if block_given?
      unless @mag_x == mag_x && @mag_y == mag_y
        @mag_x = mag_x
        @mag_y = mag_y
        update_transform
        update
      end | send_branch(:mag, na)
    end

    # See #mag!.
    def mag= param
      send_ahp :mag!, param
    end

    # Get magnification factor along X and Y axes.
    def mag
      [@mag_x, @mag_y]
    end

    # Set opacity degree.
    def opacity! opacity = @opacity
      return opacity! yield @opacity if block_given?
      return if @opacity == opacity
      Pastele.paint_set_opacity @pointer, opacity.to_i
      @opacity = opacity
      update
    end

    # See #opacity!.
    def opacity= param
      send_ahp :opacity!, param
    end

    # Get opacity degree.
    def opacity
      @opacity
    end

    # Available blending methods.
    class BlendMethod
      # Blending disabled (default).
      def self.normal = 0
      def self.add = 1
      def self.screen = 2
      def self.multiply = 3
      def self.overlay = 4
      def self.difference = 5
      def self.exclusion = 6
      def self.srcover = 7
      def self.darken = 9
      def self.lighten = 10
      def self.color_dodge = 11
      def self.color_burn = 12
      def self.hard_light = 13
      def self.soft_light = 14
    end

    # Set color blending method.
    def blend! blend = @blend
      return blend! yield @blend if block_given?
      return if @blend == blend
      Pastele.paint_set_blend_method @pointer, BlendMethod.send(blend || :normal)
      @blend = blend
      update
    end

    # See #blend!.
    def blend= param
      send_ahp :blend!, param
    end

    # Get color blending method.
    def blend
      @blend
    end

    # Available masking methods.
    class MaskMethod
      # Masking disabled (default).
      def self.none = 0
      def self.alpha = 1
      def self.inv_alpha = 2
      def self.luma = 3
      def self.inv_luma = 4
      def self.add = 5
      def self.substract = 6
      def self.intersect = 7
      def self.difference = 8
      def self.lighten = 9
      def self.darken = 10
    end

    # Set color masking method with +target+.
    def mask! mask = @mask, target = nil
      return send_ahp :mask!, yield(@mask, @mask_target) if block_given?
      return if @mask == mask && @mask_target == target
      @mask_target&.unset_masking
      target&.set_masking self
      Pastele.paint_set_mask @pointer, target&.pointer, MaskMethod.send(mask || :none)
      @mask = mask
      @mask_target = target
      update
    end

    # See #mask!.
    def mask= param
      send_ahp :mask!, param
    end

    # Get color masking method.
    def mask
      @mask
    end

    # Set whether Paint is drawn on the scene.
    #
    # Containing Kredki::Scene and all lower level Scenes must be shown for the Paint to be displayed on the screen.
    def show! value = true
      return if (c = show) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      set_show value
      true
    end

    # See #show!.
    def show= value
      show! value
    end
    
    # Get whether Paint is drawn on the screen.
    def show
      get_show
    end

    # See #show.
    def show?
      !!show
    end

    # Set the Kredki::Shape to use as the Paint clipping path.
    def clip! clip = @clip
      return yield @clip if block_given?
      clip = nil unless clip
      return if @clip == clip
      @clip&.unset_masking
      clip&.set_masking self
      Pastele.paint_set_clip @pointer, clip&.pointer
      @clip = clip
      update
    end

    # See #clip!.
    def clip= param
      send_ahp :clip!, param
    end

    # Get the Kredki::Shape used as the Paint clipping path.
    def clip
      @clip
    end

    # Get the extreme coordinates occupied by the Paint.
    def bounds
      bounds = Pastele::Bounds.malloc(Fiddle::RUBY_FREE)
      Pastele.paint_get_bounds @pointer, bounds
      bounds
    end

    # Detach the Paint from the containing Kredki::Scene.
    def detach
      @scene&.remove_paint self
      @scene = nil
    end

    # Attach the Paint to the Kredki::Scene.
    def attach scene, show = true, at = nil
      @scene&.remove_paint self
      scene.put_paint self, show, at
      @scene = scene
    end

    # Stop showing the Paint.
    def hide!
      set_show false
    end

    # Get Kredki::WindowScene ancestor.
    def window
      @scene&.window
    end

    # Push the feature.
    def << feature
      case feature
      when Hash
        alter **feature
      when Array
        alter *feature
      when Proc
        alter &feature
      else
        raise "Unsupported << (#{feature} : #{feature.class})"
      end
      self
    end

    # Get features.
    def to_hash
      {
        x: @x,
        y: @y,
        rot: @rot,
        mag_x: @mag_x,
        mag_y: @mag_y,
        opacity: @opacity,
        blend: @blend,
      }
    end

    # :section: LEVEL 2

    def initialize pointer
      @pointer = pointer
      @scene = nil
      @x = 0
      @y = 0
      @rot = 0
      @mag_x = 1
      @mag_y = 1
      @opacity = 255
      @blend = nil
    end

    attr :pointer
    attr_accessor :scene

    def inspect
      "#{self.class}:#{object_id}"
    end

    def set_masking scene
      @scene&.remove_paint self unless @is_mask
      @scene = scene
      @is_mask = true
    end

    def unset_masking
      @scene = nil
      @is_mask = false
    end

    def update
      if @is_mask
        @scene.update
      else
        @scene&.update_paint self
        true
      end
    end

    def set_show show
      show ? @scene&.show_paint(self) : @scene&.hide_paint(self)
    end

    def get_show direct = false
      @scene&.paint_shown self, direct
    end

    def pivot_xy
      [0, 0]
    end

    def update_transform
      Pastele.paint_set_transform @pointer, *pivot_xy, @x, @y, @rot, @mag_x, @mag_y
    end
  end#Paint
end#Kredki
