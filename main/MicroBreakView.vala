/*
 * This file is part of Brain Break.
 * 
 * Brain Break is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Brain Break is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Brain Break.  If not, see <http://www.gnu.org/licenses/>.
 */

/* TODO: notification when user is away for rest duration */
/* TODO: replace pause break if appropriate */

using Notify;

public class MicroBreakView : TimerBreakView {
	public MicroBreakView(MicroBreak micro_break) {
		base(micro_break);
		
		this.title = _("Micro break");
		this.warn_time = 15;
		
		this.status_widget.set_message("Take a moment to rest your eyes");
	}
	
	public override Notify.Notification get_start_notification() {
		Notify.Notification notification = new Notification(_("Time for a micro break"), null, null);
		return notification;
	}
	
	public override Notify.Notification get_finish_notification() {
		Notify.Notification notification = new Notification(_("Micro break finished"), null, null);
		return notification;
	}
}

