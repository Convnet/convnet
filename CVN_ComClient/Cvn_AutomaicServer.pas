unit Cvn_AutomaicServer;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AxCtrls, Classes,
convnet_TLB, StdVcl;

type
  TConvnetClient = class(TAutoObject, IConnectionPointContainer, IConvnetClient)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IConvnetClientEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
  public
    procedure Initialize; override;
  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;

  end;

implementation

uses ComServ;

procedure TConvnetClient.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IConvnetClientEvents;
end;

procedure TConvnetClient.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TConvnetClient, Class_ConvnetClient,
    ciMultiInstance, tmApartment);
end.
