/*
* SPDX-License-Identifier: GPL-3.0-or-later
* SPDX-FileCopyrightText: {{YEAR}} {{DEVELOPER_NAME}} <{{DEVELOPER_EMAIL}}>
*/

public class MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            default_height: 1,
            default_width: 150,
            resizable: false,
            icon_name: ".justroll",
            title: _("Justroll")
        );
    }

    static construct {
		weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_for_display (Gdk.Display.get_default ());
		default_theme.add_resource_path ("io/github/teamcons/justroll/");
	}

    construct {
        // Set default elementary thme
        var gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.gtk_icon_theme_name = "elementary";

        if (!(gtk_settings.gtk_theme_name.has_prefix ("io.elementary.stylesheet"))) {
            gtk_settings.gtk_theme_name = "io.elementary.stylesheet.blueberry";
        }

        var settings = new Settings ("io.github.teamcons.justroll");

        // We need to hide the title area for the split headerbar
        var everything = new Gtk.Box (HORIZONTAL, 6) {
            halign = Gtk.Align.START,
            tooltip_text = _("Roll a dice with the specified amount of sides"),
        };

        var diceentry = new Gtk.Entry () {
            text = settings.get_int ("lastroll").to_string (),
            xalign = 0.5f,
            placeholder_text = "Sides",
            width_request = 40,
        };

        var letsgo = new Gtk.Button () {
            label = _("Roll"),
            halign = Gtk.Align.START
        };

        var rollresult = new Gtk.Label (_("")) {
            width_request = 50,
            halign = Gtk.Align.CENTER
        };
        rollresult.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

        //everything.append (new Gtk.Label(_("Dice with ")));
        everything.append (letsgo);
        everything.append (diceentry);
        everything.append (new Gtk.Label("=>"));
        everything.append (rollresult);

        var header = new Gtk.HeaderBar ();
        header.show_title_buttons = true;

        titlebar = header;
        header.title_widget = everything;

        letsgo.clicked.connect (() => {
            var upper = int.parse (diceentry.text);
            settings.set_int ("lastroll", upper);

            var result = Random.int_range(1,(upper + 1));
            rollresult.label = result.to_string ();
        });
        letsgo.clicked ();


    }
}