unit CaptionEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCaptionEditDlg = class (TForm)
    CancelBtn: TButton;
    CaptionEdit: TMemo;
    FontBtn: TButton;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    OkBtn: TButton;
    procedure FontBtnClick(Sender: TObject);
  public
    class procedure NewCaption(var TheCaption : string;TheFont : TFont);
  end;
  

implementation

{$R *.DFM}

{
******************************* TCaptionEditDlg ********************************
}
procedure TCaptionEditDlg.FontBtnClick(Sender: TObject);
begin
  if FontDialog1.Execute then begin
    CaptionEdit.Font := FontDialog1.Font;
  end;
end;

class procedure TCaptionEditDlg.NewCaption(var TheCaption : string;TheFont : 
        TFont);
begin
  {NewCaption}
  with TCaptionEditDlg.Create(Application) do begin
    try
      CaptionEdit.Text := TheCaption;
      FontDialog1.Font := TheFont;
  
      if ShowModal = mrOk then begin
        TheCaption := CaptionEdit.Text;
        TheFont.Assign(CaptionEdit.Font);
      end;
    finally
      Release;
    end;
  end;
end;



end.

