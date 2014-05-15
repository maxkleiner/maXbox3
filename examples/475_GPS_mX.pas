unit GPSUtils_Demo;

//http://www.eye4software.com/products/gpstoolkit/source/delphi/nmea0183/
//#locs:182
//#sign:Administrator: PC08: 15/05/2014 11:51:41 AM 
//http://projecteuler.net/


//Declare and create the object(s)

{First, we have to include some units to be able to use ActiveX controls in our Delphi project. We need to include the following units: OleServer, ComObj, ActiveX. You can modify code like this:}

//7uses
  //Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //Dialogs, StdCtrls, ExtCtrls, OleServer, ComObj, ActiveX;

{Now we are ready to declare and the GPS Toolkit objects. You can add the defintion in the "private" declarations section at the top of the source file:}

//private:
{  var
  objGps         : Variant;
  objConstants   : Variant;

create the GPS Toolkit objects in the form, double click on the form to create and edit the FormCreate handler:

  objGps            := CreateOleObject ( 'Eye4Software.Gps' );
  objGpsConstants   := CreateOleObject ( 'Eye4Software.GpsConstants' );

After these steps, you can start with programming the rest of the GPS code.
The source code

Below you can find the sourcecode from the Borland Delphi demo as shipped with the GPS Toolkit.  }

//unit GPSDemo;

interface

{uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleServer, ComObj, ActiveX;}

//type
  //TForm1 = class(TForm)
    var
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBoxDevice: TComboBox;
    ComboBoxSpeed: TComboBox;
    ButtonStart: TButton;
    ButtonStop: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EditLatitude: TEdit;
    EditLongitude: TEdit;
    EditSpeed: TEdit;
    EditCourse: TEdit;
    EditAltitude: TEdit;
    EditTime: TEdit;
    EditFix: TEdit;
    EditSats: TEdit;
    GroupBox3: TGroupBox;
    LabelStatus: TLabel;
    Timer1: TTimer;
    Label11: TLabel;
    procedure TForm1_FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
  //private

  var
    objGps        : Variant;

  //public
    { Public declarations }
  //end;

var
  Form1: TForm;

implementation

//{$R *.dfm}

{//////////////////////////////////////////////////////////////////////////////}

procedure TForm1_FormCreate(Sender: TObject);
var i : Integer;
begin

  objGps        := CreateOleObject ( 'Eye4Software.Gps' );

  ComboBoxDevice.Items.Add ( 'Garmin USB' );

  for i := 1 to 16 do
  begin
    ComboBoxDevice.Items.Add('COM' + IntToStr ( i ) );
  end;

  ComboBoxDevice.ItemIndex := 1;

  ComboBoxSpeed.Items.Add ( '1200' );
  ComboBoxSpeed.Items.Add ( '2400' );
  ComboBoxSpeed.Items.Add ( '4800' );
  ComboBoxSpeed.Items.Add ( '9600' );
  ComboBoxSpeed.Items.Add ( '19200' );
  ComboBoxSpeed.Items.Add ( '38400' );
  ComboBoxSpeed.Items.Add ( '57600' );
  ComboBoxSpeed.Items.Add ( '115200' );

  ComboBoxSpeed.ItemIndex := 2;

end;

{//////////////////////////////////////////////////////////////////////////////}

procedure ButtonStartClick(Sender: TObject);
begin
  objGps.DeviceSerialPort := ComboBoxDevice.ItemIndex;
  objGps.DeviceBaudrate   := StrToInt ( ComboBoxSpeed.Text );

  objGps.Open;

  LabelStatus.Caption := objGps.LastErrorDescription;

  if ( objGps.LastError = 0 ) then begin
    ButtonStart.Enabled := False;
    ButtonStop.Enabled := True;
    Timer1.Enabled := True;
  end;
end;

{//////////////////////////////////////////////////////////////////////////////}

procedure ButtonStopClick(Sender: TObject);
begin
  objGps.Close;

  LabelStatus.Caption := objGps.LastErrorDescription;

  if ( objGps.LastError = 0 ) then begin
    ButtonStart.Enabled := True;
    ButtonStop.Enabled := False;
    Timer1.Enabled := False;
  end;
end;

{//////////////////////////////////////////////////////////////////////////////}

procedure Timer1Timer(Sender: TObject);
begin
  EditLatitude.Text :=  objGps.gpsLatitudeString;
  EditLongitude.Text := objGps.gpsLongitudeString;
  EditSpeed.Text :=  FloatToStr ( objGps.gpsSpeed );
  EditCourse.Text :=  FloatToStr ( objGps.gpsCourse );
  EditAltitude.Text := FloatToStr ( objGps.gpsAltitude );
  EditFix.Text := IntToStr ( objGps.gpsQuality );
  EditSats.Text := IntToStr ( objGps.gpsSatellites );
  EditTime.Text := objGps.gpsTimeString;
end;

{//////////////////////////////////////////////////////////////////////////////}


begin
 if isInternet then 
     //wGet('http://www.softwareschule.ch/download/maxbox_starter4.pdf','mytestpdf.pdf');
     
     //openDoc('http://www.eye4software.com/products/gpstoolkit/source/delphi/nmea0183/');
     //S_ShellExecute('http:'+getHostIP+':'+IntToStr(APORT)+'/','',seCmdOpen)
     S_ShellExecute('http://www.eye4software.com/products/gpstoolkit/source/delphi/nmea0183/','',seCmdOpen)
     
     //http://www.eye4software.com/products/gpstoolkit/source/delphi/nmea0183/'
end.



  //maXbox converted by mX
  

