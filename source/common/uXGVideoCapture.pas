unit uXGVideoCapture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MMSystem,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxContainer, cxEdit,
  cxLookAndFeelPainters, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel,
  { Custom }
  uVideoFrames,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  TransparentForm;

type
  TXGVideoCaptureForm = class(TForm)
    imgBack: TImage;
    btnClose: TAdvShapeButton;
    lblFormTitle: TLabel;
    cxLabel7: TcxLabel;
    cbxDeviceList: TcxComboBox;
    cxLabel1: TcxLabel;
    cbxDisplayMode: TcxComboBox;
    cxLabel2: TcxLabel;
    cbxResolution: TcxComboBox;
    btnRun: TAdvShapeButton;
    AdvShapeButton2: TAdvShapeButton;
    AdvShapeButton3: TAdvShapeButton;
    AdvShapeButton4: TAdvShapeButton;
    Image2: TImage;
    Label1: TLabel;
    TransparentForm: TTransparentForm;
    lblFps: TcxLabel;
    pbxVideo: TPaintBox;
    lblDifference: TcxLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FVideoImage: TVideoImage;
    FInitialized: Boolean;
    FOnNewFrameBusy: Boolean;
    FFrameCnt: Integer;
    FSkipCnt: Integer;
    F30FrameTick: Integer;
    FFVideoBmpIndex: integer;
    FVideoBmps: array[0..1] of TBitmap;
    FDiffRatio: Double;

    procedure UpdateDeviceList;
    procedure OnNewFrame(Sender : TObject; Width, Height: integer; DataPtr: pointer);
  public
    { Public declarations }
  end;

var
  XGVideoCaptureForm: TXGVideoCaptureForm;

implementation

{$R *.dfm}

procedure TXGVideoCaptureForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGVideoCaptureForm.FormCreate(Sender: TObject);
begin
  FVideoImage := TVideoImage.Create;
  FVideoImage.SetDisplayCanvas(nil); // For drawing video by ourself
  FVideoImage.OnNewVideoFrame := OnNewFrame;
end;

procedure TXGVideoCaptureForm.UpdateDeviceList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  FVideoImage.GetListOfDevices(SL);
  cbxDeviceList.Properties.Items.Assign(SL);
  SL.Free;

  btnRun.Enabled := False;
  if (cbxDeviceList.Properties.Items.Count > 0) then
  begin
    if (cbxDeviceList.ItemIndex < 0) or
       (cbxDeviceList.ItemIndex >= cbxDeviceList.Properties.Items.Count) then
      cbxDeviceList.ItemIndex := 0;
    btnRun.Enabled := True;
  end
  else
    btnRun.Enabled := False;
end;

procedure TXGVideoCaptureForm.OnNewFrame(Sender : TObject; Width, Height: integer; DataPtr: pointer);
VAR
  i, x, y, nTick: integer;
  d: double;
  s: string;
  hour, min, sec, msec: word;
begin
  Inc(FFrameCnt);
  If FOnNewFrameBusy then
  begin
    Inc(FSkipCnt);
    Exit;
  end;

  FOnNewFrameBusy := True;
  if ((FFrameCnt mod 30) = 0) then
  begin
    nTick := TimeGetTime;
    if (F30FrameTick > 0) then
      lblFPS.Caption := 'fps: ' + FloatToStrf(30000 / (nTick - F30FrameTick), ffFixed, 16, 1) +
                           ' [' + FloatToStrf(FVideoImage.FramesPerSecond, ffFixed, 16, 1) +
                           '] (' + IntToStr(fSkipCnt)+' [' + IntToStr(FVideoImage.FramesSkipped) + '] skipped)';
    f30FrameTick := nTick;
  end;

  // In the following part the actual video frame is retreived from VideoImage and than
  // painted to the Paintbox_Video. This is usefull, if the image is to be modified
  // before painting. Otherwise we could have set "VideoImage.SetDisplayCanvas(PaintBox_Video.Canvas);"
  // in routine InitFrame below, and the painting would have been done by VideoImage.

  FFVideoBmpIndex := (1 - FFVideoBmpIndex);
  FVideoImage.GetBitmap(FVideoBmps[FFVideoBmpIndex]);

  IF (cbxDisplayMode.ItemIndex <= 0) then
  begin
    pbxVideo.Canvas.Draw(0, 0, FVideoBmps[FFVideoBmpIndex]);
  end else
  begin
    FDiffRatio := 0;
    case cbxDisplayMode.ItemIndex of
      1: CalcInvertedImage(FVideoBmps[FVideoBmpIndex], ModeBMP);
      2: CalcGrayScaleImage(FVideoBmps[FVideoBmpIndex], ModeBMP);
      3: CalcDiffImage(FVideoBmps[FVideoBmpIndex], FVideoBmps[1-FVideoBmpIndex], ModeBMP, DiffRatio);
      4, 5: CalcDiffImage2(FVideoBmps[FVideoBmpIndex], FVideoBmps[1-FVideoBmpIndex], ModeBMP, DiffRatio);
    else
      ModeBMP.Assign(FVideoBmps[FFVideoBmpIndex]);
    end;
    pbxVideo.Canvas.Draw(0, 0, ModeBMP);
    lblDifference.Caption := 'Diff-Ratio: ' + FloatToStrF(DiffRatio*100, ffFixed, 16, 3) + '%';

    IF (DiffRatio > 0.03/100) and (ComboBox_DisplayMode.ItemIndex = 5) THEN
      BEGIN
        CopyBMP.Width := FVideoBmps[FVideoBmpIndex].Width;
        CopyBMP.Height := FVideoBmps[FVideoBmpIndex].Height;
        CopyBMP.Canvas.Draw(0, 0, FVideoBmps[FVideoBmpIndex]);
        WITH CopyBMP DO
          begin
            DecodeTime(Now, hour, min, sec, msec);
            Canvas.Brush.Style := bsClear;
            Canvas.TextOut(4, Height-4-Canvas.TextHeight('W'), DateTimetoStr(Now));
            Canvas.Brush.Style := bsSolid;
            Canvas.ellipse(4, 4, 36, 36);
            Canvas.Pen.Color := clBlack;
            FOR i := 0 TO 11 DO
              BEGIN
                Canvas.Pen.Color := clGray;
                Canvas.Brush.Color := clBlack;
                X := round(20 + 12*Sin(i*30*Pi/180));
                Y := round(20 - 12*cos(i*30*Pi/180));
                Canvas.ellipse(X-2, Y-2, X+2, Y+2);
              END;
            Canvas.Pen.Color := clBlack;
            d := (Hour + min/60) *30 *Pi/180;
            X := round(20 + 7*Sin(d));
            Y := round(20 - 7*cos(d));
            Canvas.Pen.Width := 3;
            Canvas.moveto(20, 20);
            Canvas.LineTo(X, Y);
            Canvas.Pen.Width := 1;
            Canvas.Pen.Color := clBlue;
            d := (Min + Sec/60) *6 *Pi/180;
            X := round(20 + 10*Sin(d));
            Y := round(20 - 10*cos(d));
            Canvas.moveto(20, 20);
            Canvas.LineTo(X, Y);
            Canvas.Pen.Color := clRed;
            d := (sec) *6 *Pi/180;
            X := round(20 + 10*Sin(d));
            Y := round(20 - 10*cos(d));
            Canvas.moveto(20, 20);
            Canvas.LineTo(X, Y);
          end;

        ForceDirectories(AppPath + 'Spy\');
        Inc(SpyIndex);
        IF SpyIndex <= 4000 then
         begin
           s := IntToStr(SpyIndex);
           while length(s) < 4 do
             s := '0' + s;
           LocalJPG.Assign(CopyBMP);
           LocalJPG.SaveToFile(AppPath + 'Spy\Spy_'+s+'.jpg');
           //FVideoBmps[FVideoBmpIndex].SaveToFile(AppPath + 'Spy\Spy_'+s+'.bmp');
         end;
      END;
  end;

  FOnNewFrameBusy := False;
end;

end.
