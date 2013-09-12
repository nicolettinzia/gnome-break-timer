/*
 * This file is part of GNOME Break Timer.
 * 
 * GNOME Break Timer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * GNOME Break Timer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with GNOME Break Timer.  If not, see <http://www.gnu.org/licenses/>.
 */

public class CircleCounter : Gtk.Widget {
	protected const double LINE_WIDTH = 5.0;
	protected const int DEFAULT_RADIUS = 48;

	public enum Direction {
		COUNT_DOWN,
		COUNT_UP
	}

	public Direction direction {get; set;}
	public double progress {get; set;}

	public CircleCounter () {
		Object ();
		this.set_has_window (false);

		this.notify["progress"].connect((s, p) => {
			this.queue_draw ();
		});
	}

	public override bool draw (Cairo.Context cr) {
		Gtk.StyleContext style_context = this.get_style_context ();
		Gtk.StateFlags state = this.get_state_flags ();
		Gtk.Allocation allocation;
		this.get_allocation (out allocation);

		int center_x = allocation.width / 2;
		int center_y = allocation.height / 2;
		int radius = int.min(center_x, center_y);
		double arc_radius = radius - LINE_WIDTH / 2;

		// FIXME: Get some nicer colours from CSS?
		Gdk.RGBA trough_color = style_context.get_color (state);
		trough_color.alpha = trough_color.alpha / 5;
		Gdk.RGBA base_color = style_context.get_color (state);

		Gdk.cairo_set_source_rgba (cr, trough_color);
		cr.arc (center_x, center_y, arc_radius, 0, Math.PI * 2.0);
		cr.set_line_width (LINE_WIDTH);
		cr.stroke ();

		double start_angle = 1.5 * Math.PI;
		double progress_angle = this.progress * Math.PI * 2.0;
		if (this.direction == Direction.COUNT_DOWN) {
			if (progress_angle > 0) {
				cr.arc (center_x, center_y, arc_radius, start_angle, start_angle - progress_angle);
			} else {
				// No progress: Draw a full circle (to be gradually emptied)
				cr.arc (center_x, center_y, arc_radius, start_angle, start_angle + Math.PI * 2.0);
			}
		} else {
			if (progress_angle > 0) {
				cr.arc_negative (center_x, center_y, arc_radius, start_angle, start_angle - progress_angle);
			}
			// No progress: Draw nothing (arc will gradually appear)
		}

		Gdk.cairo_set_source_rgba (cr, base_color);
		cr.set_line_width (LINE_WIDTH);
		cr.set_line_cap  (Cairo.LineCap.ROUND);
		cr.stroke ();

		return true;
	}

	public override void get_preferred_width (out int minimum_width, out int natural_width) {
		var diameter = calculate_diameter ();
		minimum_width = diameter;
		natural_width = diameter;
	}

	public override void get_preferred_height (out int minimum_height, out int natural_height) {
		var diameter = calculate_diameter ();
		minimum_height = diameter;
		natural_height = diameter;
	}

	public override void size_allocate (Gtk.Allocation allocation) {
		base.size_allocate (allocation);
	}

	private int calculate_diameter () {
		return 2 * DEFAULT_RADIUS;
	}
}