uses 
  W3System, ArchSpiralMain;

var Application: TApplication;
try
  InitVendorInfo;
  Application := TApplication.Create$43;
  Application.RunApp;
except
  on e: Exception do
    ShowMessage$1(e$7.Message);
end;
