/**
 * Radio Button
 */

public class RadioButtonGroup
{
  private boolean isRadio;
  private ArrayList<RadioButton> buttons = new ArrayList<RadioButton>();
  private String value;
  
  public RadioButtonGroup()
  {
    this(true);
  }
  
  public RadioButtonGroup(boolean isRadio)
  {
    this.isRadio = isRadio;
  }
  
  public void add(RadioButton button)
  {
    buttons.add(button);
    button.addToGroup(this);
  }
  
  public boolean isRadioButton()
  {
    return isRadio;
  }
  
  public void setValue(String value)
  {
    if(this.value != value)
    {
      if(isRadioButton())
      {
        if(this.value != null)
        {
          for (int i = 0; i < buttons.size(); i++)
          {
            if(buttons.get(i).getId() == this.value)
            {
              buttons.get(i).reset();
              break;
            }
          }
        }
      }
      
      this.value = value;
      
      if(this.value != null)
      {
        for (int i = 0; i < buttons.size(); i++)
        {
          if(buttons.get(i).getId() == this.value)
          {
            buttons.get(i).toggle();
            break;
          }
        }
      }
    }
  }
  
  public String getValue()
  {
    return value;
  }

  public ArrayList<String> getValues()
  {
    ArrayList<String> ret = new ArrayList<String>();
    for (int i = 0; i < buttons.size(); i++)
    {
      if(buttons.get(i).isChecked())
      {
        ret.add(buttons.get(i).getId());
      }
    }
    return ret;
  }
  
  public void draw()
  {
    for (int i = 0; i < buttons.size(); i++)
    {
      buttons.get(i).draw();
    }
  }
  
  public void mousePressed()
  {
    for (int i = 0; i < buttons.size(); i++)
    {
      buttons.get(i).mousePressed();
    }
  }
}

public class RadioButton
{
  private final static int DEFAULT_DIAMETER = 20;

  private String id;
  private String text;
  private int x;
  private int y;
  private int diameter;
  private boolean value;
  private RadioButtonGroup group;
  
  public RadioButton(String id, String text, int x, int y)
  {
    this(id, text, x, y, DEFAULT_DIAMETER);
  }
  
  public RadioButton(String id, String text, int x, int y, int diameter)
  {
    this.id = id;
    this.text = text;
    this.x = x;
    this.y = y;
    this.diameter = diameter;
  }
  
  public void draw()
  {
    if (internalOver(x, y, diameter))
    {
      fill(color(200));
    }
    else
    {
      fill(color(250));
    }
    stroke(0);
    internalDraw(x, y, diameter, diameter);
    
    textAlign(LEFT);
    text(text, x + int(diameter * 1.1), y + int(diameter * 0.4)); 
    
    if(isChecked())
    {
      fill(color(40));
      internalDraw(x, y, int(diameter * 0.5), int(diameter * 0.5));
    }
  }
  
  public void mousePressed()
  {
    if(internalOver(x, y, diameter))
    {
      toggle();
    }
  }
  
  public void addToGroup(RadioButtonGroup group)
  {
    this.group = group;
  }
  
  public String getId()
  {
    return id;
  }
  
  public void reset()
  {
    this.value = false;
  }
  
  public void toggle()
  {
    if(group != null && group.isRadioButton())
    {
      if(!this.value)
      {
        this.value = !this.value;
        group.setValue(id);
      }
    }
    else
    {
      this.value = !this.value;
    }
  }
    
  public boolean isChecked()
  {
    return value;
  }
  
  // ---
  private boolean isRadioButton()
  {
    if(group == null)
    {
      return false;
    }
    else
    {
      return group.isRadioButton();
    }
  }
  
  private void internalDraw(int x, int y, int width, int height)
  {
    if(isRadioButton())
    {
      ellipse(x, y, width, height);
    }
    else
    {
      rect(x, y, width, height);
    }
  }
  
  private boolean internalOver(int x, int y, int diameter)
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if ((!isRadioButton()) && ((abs(disX) < diameter/2) && (abs(disY) < diameter/2)))
    {
      return true;
    }
    else if ((isRadioButton()) && (sqrt(sq(disX) + sq(disY)) < diameter/2 ))
    {
      return true;
    }
    else
    {
      return false;
    }
  }
}
