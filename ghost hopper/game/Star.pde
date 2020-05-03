class Star {
  float xCoord, yCoord;
  float diameter;
  int red, green, blue;

  Star() {
  }

  void position(float xPos, float yPos, float diamtr) {
    xCoord = xPos;
    yCoord = yPos;
    diameter = diamtr;
  }

  void colour(int redValue, int greenValue, int blueValue) {
    red = redValue;
    green = greenValue;
    blue = blueValue;
    fill (red, green, blue);
  }

  void display() {
    ellipse(xCoord, yCoord, diameter, diameter);
  }
}
