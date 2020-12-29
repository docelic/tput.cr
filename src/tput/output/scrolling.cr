class Tput
  module Output
    module Scrolling
      include Crystallabs::Helpers::Alias_Methods
      #include Crystallabs::Helpers::Boolean
      include Macros

      # ESC D Index (IND is 0x84).
      def index
        @cursor.y+=1
        _ncoords
        put(ind?) || _print "\x1bD"
      end
      alias_previous ind

      # ESC M Reverse Index (RI is 0x8d).
      def reverseIndex
        @cursor.y-=1
        _ncoords
        put(ri?) || _print "\x1bM"
      end
      alias_previous ri, reverse

      # CSI Ps S  Scroll up Ps lines (default = 1) (SU).
      def scroll_up(param=1)
        @cursor.y -= param
        _ncoords
        put(parm_index?(param)) || _print { |io| io << "\x1b[" << param << "S" }
      end
      alias_previous su

      # CSI Ps T  Scroll down Ps lines (default = 1) (SD).
      def scroll_down(param=1)
        @cursor.y += param
        _ncoords
        put(parm_rindex?(param)) || _print { |io| io << "\x1b[" << param << "T" }
      end
      alias_previous sd

      # CSI Ps ; Ps r
      #   Set Scrolling Region [top;bottom] (default = full size of win-
      #   dow) (DECSTBM).
      # CSI ? Pm r
      def set_scroll_region(top=0, bottom=(@screen.height - 1))
        @scroll_top = top
        @scroll_bottom = bottom
        @cursor.x = 0
        @cursor.y = 0
        _ncoords
        put(csr?(top,bottom)) || _print { |io| io << "\x1b[" << top+1 << ';' << bottom+1 << 'r' }
      end
      alias_previous decstbm, csr

    end
  end
end
