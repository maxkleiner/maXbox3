import gnu.regexp.*;
import java.awt.*;
import java.applet.*;
import sun.audio.*;
import java.util.*;

/*

--------------------------------------------------------------------------------

Morse Code Translator Java Applet
Copyright (C) 1999-2004  Stephen C Phillips

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

--------------------------------------------------------------------------------

You can contact me by email at: morse@scphillips.com

--------------------------------------------------------------------------------

Version 1.2.0   2004-08-09 ext to maXbox MORSIX  2014-08-13

Added the at sign and equals sign.  Added my name to the applet display(!)
Version 1.1.0	2001-06-28
Added a few more playback speeds
Version 1.0.1	1999-08-23
Minor correction to translate action button
Version 1.0.0	1999-08-10
First public release  
--------------------------------------------------------------------------------

*/

    public class Morse extends Applet {
        byte [] sample = null;
        AudioData playable = null;
        private Button playButton;
        private Button transButton;
        private TextArea input;
        private Choice wpmChoice;
        private TextArea output;
        private int wpm = 15;
        private Hashtable hMorse;
        private Hashtable hText;
        private String morse;
        private String text;

        public void init() {
            setBackground(Color.lightGray);
            Font butFont = new Font("Helvetica", Font.PLAIN, 10);

            GridBagLayout gbag = new GridBagLayout();
            setLayout(gbag);
            GridBagConstraints con = new GridBagConstraints();

            Label l4 = new Label("Morse Code Translator", Label.CENTER);
            l4.setFont(new Font("Helvetica", Font.BOLD, 16));
            con.gridx = 0;
            con.gridy = 0;
            con.gridwidth = 6;
            con.anchor = GridBagConstraints.CENTER;
            //con.fill = GridBagConstraints.HORIZONTAL;
            con.weightx = 1.0;
            gbag.setConstraints(l4, con);
            add(l4);

            Label l2 = new Label("Input", Label.CENTER);
            l2.setFont(new Font("Helvetica", Font.BOLD, 12));
            con.gridx = 0;
            con.gridy = 1;
            gbag.setConstraints(l2, con);
            add(l2);

            input = new TextArea(2, 80);
            input.setEditable(true);
            input.setFont(new Font("Courier", Font.PLAIN, 10));
            con.gridx = 0;
            con.gridy = 2;
            gbag.setConstraints(input, con);
            add(input);

            Label l3 = new Label("Translation", Label.CENTER);
            l3.setFont(new Font("Helvetica", Font.BOLD, 12));
            con.gridx = 0;
            con.gridy = 3;
            gbag.setConstraints(l3, con);
            add(l3);

            output = new TextArea(2, 80);
            output.setEditable(false);
            output.setFont(new Font("Courier", Font.PLAIN, 10));
            con.gridx = 0;
            con.gridy = 4;
            gbag.setConstraints(output, con);
            add(output);

            transButton = new Button("Translate");
            transButton.setFont(butFont);
            transButton.setForeground(Color.black);
            transButton.setBackground(Color.lightGray);
            con.gridx = 0;
            con.gridy = 5;
            con.gridwidth = 3;
            con.ipadx = 2;
            con.ipady = 2;
            con.insets = new Insets(6,0,0,0);
            gbag.setConstraints(transButton, con);
            add(transButton);

            Panel p1 = new Panel();
            GridBagLayout gbag1 = new GridBagLayout();
            p1.setLayout(gbag1);

            con.gridx = 3;
            con.gridy = 5;
            con.gridwidth = 3;
            con.ipadx = 0;
            con.ipady = 0;
            gbag.setConstraints(p1, con);
            add(p1);

            //sub panel
            playButton = new Button("Play");
            playButton.setFont(butFont);
            playButton.setForeground(Color.black);
            playButton.setBackground(Color.lightGray);
            con.gridx = 0;
            con.gridy = 0;
            con.gridwidth = 1;
            con.ipadx = 2;
            con.ipady = 2;
            con.insets = new Insets(0,0,0,0);
            gbag1.setConstraints(playButton, con);
            p1.add(playButton);

            Label l5 = new Label("at");
            l5.setFont(butFont);
            con.gridx = 1;
            con.gridy = 0;
            con.ipadx = 0;
            con.ipady = 0;
            gbag1.setConstraints(l5, con);
            p1.add(l5);

            wpmChoice = new Choice();
            wpmChoice.setFont(butFont);
            wpmChoice.addItem("5");
            wpmChoice.addItem("10");
            wpmChoice.addItem("13");
            wpmChoice.addItem("15");
            wpmChoice.addItem("16");
            wpmChoice.addItem("17");
            wpmChoice.addItem("18");
            wpmChoice.addItem("19");
            wpmChoice.addItem("20");
            wpmChoice.addItem("25");
            wpmChoice.addItem("30");
            wpmChoice.addItem("35");
            wpmChoice.addItem("40");
            wpmChoice.select(3);
            wpmChoice.setForeground(Color.black);
            wpmChoice.setBackground(Color.lightGray);
            con.gridx = 2;
            con.gridy = 0;
            gbag1.setConstraints(wpmChoice, con);
            p1.add(wpmChoice);

            Label l1 = new Label("WPM");
            l1.setFont(butFont);
            con.gridx = 3;
            con.gridy = 0;
            gbag1.setConstraints(l1, con);
            p1.add(l1);

            Label l6 = new Label("By Stephen C Phillips (www.scphillips.com)", Label.CENTER);
            l6.setFont(new Font("Helvetica", Font.BOLD, 12));
            con.gridx = 0;
            con.gridy = 6;
            con.gridwidth = 6;
            con.anchor = GridBagConstraints.CENTER;
            gbag.setConstraints(l6, con);
            add(l6);

            hMorse = new Hashtable(46);
            hText = new Hashtable(46);

            hMorse.put(new Character('A'), ".-");
            hMorse.put(new Character('B'), "-...");
            hMorse.put(new Character('C'), "-.-.");
            hMorse.put(new Character('D'), "-..");
            hMorse.put(new Character('E'), ".");
            hMorse.put(new Character('F'), "..-.");
            hMorse.put(new Character('G'), "--.");
            hMorse.put(new Character('H'), "....");
            hMorse.put(new Character('I'), "..");
            hMorse.put(new Character('J'), ".---");
            hMorse.put(new Character('K'), "-.-");
            hMorse.put(new Character('L'), ".-..");
            hMorse.put(new Character('M'), "--");
            hMorse.put(new Character('N'), "-.");
            hMorse.put(new Character('O'), "---");
            hMorse.put(new Character('P'), ".--.");
            hMorse.put(new Character('Q'), "--.-");
            hMorse.put(new Character('R'), ".-.");
            hMorse.put(new Character('S'), "...");
            hMorse.put(new Character('T'), "-");
            hMorse.put(new Character('U'), "..-");
            hMorse.put(new Character('V'), "...-");
            hMorse.put(new Character('W'), ".--");
            hMorse.put(new Character('X'), "-..-");
            hMorse.put(new Character('Y'), "-.--");
            hMorse.put(new Character('Z'), "--..");
            hMorse.put(new Character('1'), ".----");
            hMorse.put(new Character('2'), "..---");
            hMorse.put(new Character('3'), "...--");
            hMorse.put(new Character('4'), "....-");
            hMorse.put(new Character('5'), ".....");
            hMorse.put(new Character('6'), "-....");
            hMorse.put(new Character('7'), "--...");
            hMorse.put(new Character('8'), "---..");
            hMorse.put(new Character('9'), "----.");
            hMorse.put(new Character('0'), "-----");
            hMorse.put(new Character('.'), ".-.-.-");
            hMorse.put(new Character(','), "--..--");
            hMorse.put(new Character(':'), "---...");
            hMorse.put(new Character('?'), "..--..");
            hMorse.put(new Character('\''), ".----.");
            hMorse.put(new Character('-'), "-....-");
            hMorse.put(new Character('/'), "-..-.");
            hMorse.put(new Character('('), "-.--.-");
            hMorse.put(new Character(')'), "-.--.-");
            hMorse.put(new Character('"'), ".-..-.");
            hMorse.put(new Character('@'), ".--.-.");
            hMorse.put(new Character('='), "-...-");
	
            Enumeration list = hMorse.keys();
            while (list.hasMoreElements()) {
                Character c = (Character)list.nextElement();
                String s = (String)hMorse.get(c);
                hText.put(s,c);
            }
        }

        public void paint(Graphics g) {
            g.drawRect(0,0,bounds().width-1, bounds().height-1);
        }
    
        public boolean action(Event event, Object arg) {
            if (event.target == transButton) {
                if (isText(input.getText())) {
                    text = input.getText();
                    morse = toMorse(text);
                    output.setText(morse);
                } else {
                    morse = input.getText();
                    text = toText(morse);
                    output.setText(text);
                }
                return true;
            }
            if (event.target == playButton) {
                //Applet.this.showStatus(status);
                if (isText(input.getText())) {
                    text = input.getText();
                    morse = toMorse(text);
                    output.setText(morse);
                    makeSample(morse);
                } else {
                    morse = input.getText();
                    text = toText(morse);
                    output.setText(text);
                    makeSample(input.getText());  //using the processed morse
                }
                playSample();
                return true;
            }
            else if (event.target == wpmChoice) {
                if (arg.equals("5")) wpm = 5;
                else if (arg.equals("10")) wpm = 10;
                else if (arg.equals("13")) wpm = 13;
                else if (arg.equals("15")) wpm = 15;
                else if (arg.equals("16")) wpm = 16;
                else if (arg.equals("17")) wpm = 17;
                else if (arg.equals("18")) wpm = 18;
                else if (arg.equals("19")) wpm = 19;
                else if (arg.equals("20")) wpm = 20;
                else if (arg.equals("25")) wpm = 25;
                else if (arg.equals("30")) wpm = 30;
                else if (arg.equals("35")) wpm = 35;
                else if (arg.equals("40")) wpm = 40;
                //wpm = (event.target.getSelectedIndex() + 1) * 5;
                return true;
            }
            else return super.action(event, arg);
        }

        /**************************************************************/
        /*  Text Processing                                          */
        /**************************************************************/

        public boolean isText(String sText) {
            boolean matches = false;
            try {
                RE morseRE = new RE("^[._/ \\|-]*$");
                matches = morseRE.isMatch(sText);
            } 
            catch (REException arg) { }
            return !matches;
        }

        public String toMorse(String sText) {
            /*
              tr/a-z/A-Z/; #lowercase
              tr/ / /s; #sqeeze spaces
              s/^ *(.*?) *$/$1/; #chop start and end of ' '
              s# #@ #g; #mark word boundaries (with non-Morse character)
              s#([A-Z0-9.,:?'-/()"])#$toMorse{$1}.' '#eg; #put Morse in
              s#@#/#g; #re-mark word boundaries
            */

            StringBuffer sbMorse = new StringBuffer();

            sText = sText.toUpperCase();
            try {
                RE sub1 = new RE("\\s+");
                RE sub2 = new RE("^\\s+");
                RE sub3 = new RE("\\s+$");
                //RE sub4 = new RE(" ");
                RE sub5 = new RE("[^A-Z0-9.,?\'\"/() -=@]");
                sText = sub1.substituteAll(sText, " ");
                sText = sub2.substitute(sText, "");
                sText = sub3.substitute(sText, "");
                sText = sub5.substituteAll(sText, "");
                input.setText(sText);

                for (int i = 0; i < sText.length(); i++) {
                    char c = sText.charAt(i);
                    Character ch = new Character(c);
                    if (Character.isSpace(c)) {
                        sbMorse.append("/ ");
                    } else {
                        sbMorse.append(hMorse.get(ch));
                        sbMorse.append(' ');
                    }
                }
            } catch (REException arg) {
                //input.setText(arg.getMessage());
                input.setText("error");
            }

            sText = sbMorse.toString();
            return sText;
        }

        public String toText(String sMorse) {
            /*
              tr/ / /s; #sqeeze space
              s#( ?/ ?)+# /#g; #deal with multiple and space-padded '/'
              s#^[ /]*##; #chop start of '/' and ' '
              s#[ /]*$# #; #chop end of same, leaving one ' '
              s#/#@#g; #mark word boundaries (with non-Morse character)
              s/([-.]+) /$fromMorse{"$1"}/eg; #put in text
              s/@/ /g; #replace word boundaries
              s#\(([^(]*)\(#\($1\)#g; #match brackets
            */
            StringBuffer sbText = new StringBuffer();
            String letter = new String();

            try {
                RE sub1 = new RE("\\|");  // for '/'
                RE sub2 = new RE("_");  // for '-'
                RE sub3 = new RE("\\s+");  // for ' '
                RE sub4 = new RE("( ?/ ?)+");  // for ' / '
                RE sub5 = new RE("^[ /]*");  // for ''
                RE sub6 = new RE("[ /]*$");  // for ''
                sMorse = sub1.substituteAll(sMorse, "/");
                sMorse = sub2.substituteAll(sMorse, "-");
                sMorse = sub3.substituteAll(sMorse, " ");
                sMorse = sub4.substituteAll(sMorse, " / ");
                sMorse = sub5.substitute(sMorse, "");
                sMorse = sub6.substitute(sMorse, "");
                input.setText(sMorse);
                sMorse = sMorse + " ";

                RE sub7 = new RE("^.*? ");  // for ''  (rest of string)
                RE sub8 = new RE(" .*$");  // for ''  (first word)

                while (sMorse.length() != 0) {
                    letter = sub8.substitute(sMorse, "");
                    sMorse = sub7.substitute(sMorse, "");
                    if (letter.equals("/")) {
                        sbText.append(" ");
                    } else if (hText.get(letter) == null) {
                        sbText.append("*");
                    } else {
                        sbText.append(hText.get(letter));
                    }
                }
                // need to do parentheses matching!

            } catch (REException arg) {
                //input.setText(arg.getMessage());
                input.setText("error");
            }

            sMorse = sbText.toString();
            return sMorse;
        }

        /**************************************************************/
        /*  Sound Processing                                          */
        /**************************************************************/

        public void playSample() {
            AudioDataStream stream = new AudioDataStream(playable);
            AudioPlayer.player.start(stream);
        }

        public void makeSample(String morse) {
            char c;
            int dits=0, dahs=0, spcs=0, slashes=0;
            int dahLen = 3;
            int pause1 = 1;
            int pause2 = 3;
            int pause3 = 7;
            int wordLen = 50;
            int ditLen = (int)1000*60/(wpm*wordLen);  
            //thousandths of a sec per dit, or 8-byte frames per dit

            for (int i = 0; i < morse.length(); i++) {
                c = morse.charAt(i);
                //status += c;
                switch (c) {
                case '.': 
                    dits++; 
                    break;
                case '-': 
                    dahs++; 
                    break;
                case ' ': 
                    spcs++; 
                    break;
                case '/': 
                    slashes++; 
                    break;
                    //need default
                }
            }
            //status += " "+dits+" "+dahs+" "+spcs+" "+slashes;
            int length = ditLen*8*(dits*(1+pause1)+dahs*(dahLen+pause1)+spcs*(pause2-pause1)+slashes*(pause3-pause1));
	
            sample = new byte[length];
	
            int sPos = 0;
            for (int i = 0; i < morse.length(); i++) {
                c = morse.charAt(i);
                switch (c) {
                case '.': 
                    addSound(1, sPos, ditLen);
                    sPos += (1+pause1)*ditLen*8;
                    break;
                case '-': 
                    addSound(dahLen, sPos, ditLen);
                    sPos += (dahLen+pause1)*ditLen*8;
                    break;
                case ' ': 
                    sPos += (pause2-pause1)*ditLen*8;
                    break;
                case '/': 
                    sPos += (pause3-pause1)*ditLen*8;
                    break;
                }
            }
            playable = new AudioData(sample);
        }

        public void addSound(int units, int sPos, int ditLen) {
            for (int i = 0; i < units*ditLen; i++) {
                sample[sPos+i*8] = (byte)0xA7;
                sample[sPos+i*8+1] = (byte)0x81;
                sample[sPos+i*8+2] = (byte)0xA7;
                sample[sPos+i*8+3] = (byte)0;
                sample[sPos+i*8+4] = (byte)0x59;
                sample[sPos+i*8+5] = (byte)0x7F;
                sample[sPos+i*8+6] = (byte)0x59;
                sample[sPos+i*8+7] = (byte)0;
            }
        }
    }
