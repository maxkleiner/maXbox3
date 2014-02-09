/**********************************************

       Java Class used to demonstrate
       invoking a Delphi widget from Java code.
       see native2.dpr and DelphiForm.pas for the other parts
       of the demo.

       Copyright (c) 1998 Jonathan Revusky

       Java and Delphi Freelance programming
             jrevusky@bigfoot.com

**********************************************/

import java.awt.*;
import java.awt.event.*;

public class Native2 {

// loads the dll "native2.dll" when the class is loaded.

    static {
        System.loadLibrary("Native2");
    }

/** 
 * See native2.dpr for the native implementation of this method.
 */

    public native String showWidget(String[] args);

    String[] choices;
    boolean widgetCreated;
    Label feedback = new Label();
    Button clicker = new Button("Click here for native widget");

    public Native2(String[] args) {
        choices = args;
    }

/**
 * Creates the Native Delphi widget and shows it in a separate thread.
 */

    public void showIt() {
        Thread t = new Thread() {
            public void run() {
                String s = Native2.this.showWidget(choices);
                feedback.setText("You clicked on: \"" + s + "\"");
            }
        };
        t.start();
    }

    void showFrame() {
        Frame frame =new Frame("AWT Widget");
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
        clicker.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                showIt();
            }
        });
        frame.add("South", feedback);
        frame.add("North", clicker);
        frame.pack();
        frame.show();
    }

    public static void main(String[] args) {
        if (args.length == 0) {
            args = new String[] {
              "Mary", "had", "a", "little", "lamb"
            };
        }
        new Native2(args).showFrame();
    }
}
