import java.applet.Applet;
import java.awt.Graphics;
import java.awt.Color;

/*
<applet code="SmileyFace" width="400" height="400">
</applet>
*/

public class SmileyFace extends Applet {

    public void paint(Graphics g) {

        // Face
        g.setColor(Color.YELLOW);
        g.fillOval(100, 100, 200, 200);

        // Left Eye
        g.setColor(Color.BLACK);
        g.fillOval(150, 150, 20, 20);

        // Right Eye
        g.fillOval(230, 150, 20, 20);

        // Smile
        g.drawArc(150, 180, 100, 50, 180, 180);

        // Nose
        g.drawLine(200, 170, 200, 210);
    }
}

-----------------------------------------
import java.applet.Applet;
import java.awt.Graphics;
import java.awt.Color;
import java.util.Random;

/*
<applet code="ConcentricCircle" width="500" height="500">
</applet>
*/

public class ConcentricCircle extends Applet {

    public void paint(Graphics g) {

        Random randomObject = new Random();

        int radius = 20;

        for(int i = 0; i < 10; i++) {

            // Generate random color
            Color randomColor = new Color(
                randomObject.nextInt(256),
                randomObject.nextInt(256),
                randomObject.nextInt(256)
            );

            g.setColor(randomColor);

            // Draw circle
            g.drawOval(250 - radius, 250 - radius,
                       radius * 2, radius * 2);

            // Increase radius by 10
            radius = radius + 10;
        }
    }
}
---------------------------------------------------
import java.awt.*;
import java.awt.event.*;

public class Calculator extends Frame implements ActionListener {

    TextField textFieldObject;

    double number1, number2, result;

    char operator;

    Calculator() {

        // Create text field
        textFieldObject = new TextField();
        textFieldObject.setBounds(30, 50, 240, 30);

        add(textFieldObject);

        // Button names
        String buttonNames[] = {
            "7","8","9","/",
            "4","5","6","*",
            "1","2","3","-",
            "0",".","=","+",
            "C"
        };

        Button buttons[] = new Button[17];

        int x = 30;
        int y = 100;

        for(int i = 0; i < 17; i++) {

            buttons[i] = new Button(buttonNames[i]);

            buttons[i].setBounds(x, y, 50, 40);

            add(buttons[i]);

            buttons[i].addActionListener(this);

            x = x + 60;

            if((i + 1) % 4 == 0) {

                x = 30;
                y = y + 50;
            }
        }

        setSize(320, 350);

        setLayout(null);

        setVisible(true);

        addWindowListener(new WindowAdapter() {

            public void windowClosing(WindowEvent e) {

                dispose();
            }
        });
    }

    public void actionPerformed(ActionEvent e) {

        String command = e.getActionCommand();

        // Numbers and decimal point
        if((command.charAt(0) >= '0' && command.charAt(0) <= '9')
                || command.equals(".")) {

            textFieldObject.setText(
                textFieldObject.getText() + command
            );
        }

        // Clear button
        else if(command.equals("C")) {

            textFieldObject.setText("");

            number1 = number2 = result = 0;
        }

        // Arithmetic operators
        else if(command.equals("+") || command.equals("-")
                || command.equals("*") || command.equals("/")) {

            number1 = Double.parseDouble(
                textFieldObject.getText()
            );

            operator = command.charAt(0);

            textFieldObject.setText("");
        }

        // Equal button
        else if(command.equals("=")) {

            number2 = Double.parseDouble(
                textFieldObject.getText()
            );

            switch(operator) {

                case '+':
                    result = number1 + number2;
                    break;

                case '-':
                    result = number1 - number2;
                    break;

                case '*':
                    result = number1 * number2;
                    break;

                case '/':
                    result = number1 / number2;
                    break;
            }

            textFieldObject.setText(String.valueOf(result));

            number1 = result;
        }
    }

    public static void main(String[] args) {

        new Calculator();
    }
}
