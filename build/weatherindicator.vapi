/* weatherindicator.vapi generated by valac 0.40.19, do not modify. */

namespace weatherindicator {
	[CCode (cheader_filename = "weatherindicator.h")]
	public class Indicator : Wingpanel.Indicator {
		public Indicator ();
		public override void closed ();
		public override Gtk.Widget get_display_widget ();
		public override Gtk.Widget? get_widget ();
		public override void opened ();
	}
}
namespace Weather {
	namespace Widgets {
		[CCode (cheader_filename = "weatherindicator.h")]
		public class DisplayWidget : Gtk.Box {
			public DisplayWidget ();
			public void update_state (string state, double temperature);
		}
	}
}
[CCode (cheader_filename = "weatherindicator.h")]
public static Wingpanel.Indicator? get_indicator (GLib.Module module, Wingpanel.IndicatorManager.ServerType server_type);
