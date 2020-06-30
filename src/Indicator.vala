/*-
 * Copyright (c) {{yearrange}} kunal ()
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: kunal <>
 */

public class weatherindicator.Indicator : Wingpanel.Indicator {
    private Gtk.Grid main_grid;
    Weather.Widgets.DisplayWidget? display_widget = null;
    private Gtk.Image display_icon;
   // private Gtk.StyleContext style_context;
   // private Gtk.Spinner? display_icon = null;
  // private Gtk.Grid main_grid;
    
   private File config;
   
   private string key;

    public Indicator () {
        Object (code_name: "weather indicator",
                display_name: _("weatherindicator"),
                description:_("weather app"));

                try {
                    config = File.new_for_path (Environment.get_home_dir() + "/.weather.config");
                    stderr.printf("home dir: %s\n",Environment.get_home_dir());
                    
                    if (config.query_exists ()) {
        
                        var parser = new Json.Parser ();
                        var dis = new DataInputStream (config.read ());
                        
                        parser.load_from_stream(dis,null);
        
                        var root_object = parser.get_root ().get_object ();
                        key = root_object.get_string_member ("key");
                    }
                    else {
                            stderr.printf("config file NOT FOUND!\n");
                    }
                    monitor_weather();
        
                }catch (Error e) {
                    stderr.printf ("Error: %s\n", e.message);
                    return;
                    
                }         
      //  this.display_icon = new Gtk.Image.from_icon_name ("weather-clear-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    }

    public override Gtk.Widget get_display_widget () {
        if (display_widget == null) {
            display_widget = new  Weather.Widgets.DisplayWidget ();
            get_weather("",key, display_widget);
        }

        visible = true;
        return display_widget;
    }

    public override Gtk.Widget? get_widget () {
        if (main_grid == null) {
            main_grid = new Gtk.Grid ();
            main_grid.set_orientation (Gtk.Orientation.VERTICAL);
            
            main_grid.show_all ();

        }

        return main_grid;
    }
    
    private async void monitor_weather() {
        //Fetch Report every 30 Minutes
        //TODO: Should be read from configuration file
        get_weather("",key, display_widget);
        GLib.Timeout.add_seconds (1800, () => {
            get_weather("",key, display_widget);
            return true;
        },GLib.Priority.DEFAULT);
        yield;
    }

    public override void opened () { }

    public override void closed () { }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    // Temporal workarround for Greeter crash
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }
    debug ("Activating kunal widget");
    var indicator = new weatherindicator.Indicator ();
    return indicator;
}
