{
  ���������� �������������� �����������

  ��������� �� TGridView ��� ����������� ����������� ��������� ������
    
  ������ 1.8

  � ����� �. �������, 1997-2019
  E-mail: checker@mail.ru

  TODO:
    - ���� � ������� ��� �������� ����, �� �� ������ ������� ReadOnly

  $Id: Ex_DBGrid.pas, 2019/01/21 roman Exp $
}
                                            
unit Ex_DBGrid;

interface

uses
  Windows, Messages, SysUtils, CommCtrl, Classes, Controls, Graphics, Forms,
  Dialogs, StdCtrls, Math, ImgList, Ex_Grid, Db, DBCtrls, Types;

const
  DBGRID_BOF = -MaxInt;
  DBGRID_EOF = MaxInt;

type
  TCustomDBGridView = class;

{ TDBGridHeader }

  {
    ��������� �������. ���������� �� ��������� ����������� TGridView ������
    ���, ��� published �������� FullSynchrinizing  �� ��������� ����� False.
  }

  TDBGridHeader = class(TCustomGridHeader)
  public
    constructor Create(AGrid: TCustomGridView); override;
  published
    property AutoHeight;
    property AutoSynchronize;
    property Color;
    property Images;
    property Flat;
    property Font;
    property FullSynchronizing default False;
    property GridColor;
    property GridFont;
    property PopupMenu;
    property Sections;
    property SectionHeight;
    property Synchronized;
  end;

{ TDBGridColumn }

  {
    ������� ������� � �������������� ���������: ������� �� ���� ���������
    ������. ����� ������������� ���������� ��������, ������������, �����
    � ��� ������ ��������������, ������������ ����� ������, ������ � ������� 
    �������������� �� ���������� ����.

    ������:

    RestoreDefaults - ������������ �������� ������� �� ���������.

    ��������:

    DefaultColumn -   ������� ������������� �������� ���������� ����������
                      � ��� ���� ��������� ������.
    Field -           ������ �� ���� ��������� ������, ������������� �
                      ������ �������.
    FieldName -       �������� ���� �������.
  }

  TDBGridColumn = class(TCustomGridColumn)
  private
    FField: TField;
    FFieldName: string;
    FDefaultColumn: Boolean;
    function GetGrid: TCustomDBGridView;
    function IsNondefaultColumn: Boolean;
    function GetField: TField;
    procedure SetDefaultColumn(Value: Boolean);
    procedure SetField(Value: TField);
    procedure SetFieldName(const Value: string);
  protected
    function GetDisplayName: string; override;
    procedure SetAlignment(Value: TAlignment); override;
    procedure SetCaption(const Value: string); override;
    procedure SetEditMask(const Value: string); override;
    procedure SetEditStyle(Value: TGRidEditStyle); override;
    procedure SetMaxLength(Value: Integer); override;
    procedure SetReadOnly(Value: Boolean); override;
    procedure SetWidth(Value: Integer); override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure RestoreDefaults; virtual;
    property Field: TField read GetField write SetField;
    property Grid: TCustomDBGridView read GetGrid;
  published
    property AlignEdit;
    property Alignment stored IsNondefaultColumn;
    property AllowClick;
    property Caption stored IsNondefaultColumn;
    property CheckKind;
    property DefaultPopup;
    property EditMask stored IsNondefaultColumn;
    property EditStyle stored IsNondefaultColumn;
    property EditWordWrap;
    property FixedSize default False;
    property MaxLength stored IsNondefaultColumn;
    property MaxWidth;
    property MinWidth;
    property PickList;
    property ReadOnly stored IsNondefaultColumn;
    property TabStop;
    property Tag;
    property Visible default True;
    property WantReturns;
    property Width default 64;
    property WordWrap;
    property DefWidth stored IsNondefaultColumn;
    property FieldName: string read FFieldName write SetFieldName stored True;
    property DefaultColumn: Boolean read FDefaultColumn write SetDefaultColumn default True;
  end;

{ TDBGridColumns }

  TDBGridColumns = class(TGridColumns)
  private
    function GetColumn(Index: Integer): TDBGridColumn;
    function GetGrid: TCustomDBGridView;
    procedure SetColumn(Index: Integer; Value: TDBGridColumn);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TDBGridColumn;
    property Columns[Index: Integer]: TDBGridColumn read GetColumn write SetColumn; default;
    property Grid: TCustomDBGridView read GetGrid;
  end;

{ TDBGridRows }

  {
    ������ �������. ���������� �� ����� ����������� TGridView ������
    ���, ��� �� ����� published �������� Count, �.�. ���������� �����
    ��������������� �������� ������������� � �� �������� ��������� �������.
  }

  TDBGridRows = class(TCustomGridRows)
  private
    FRowsFromGrid: Integer;
    function GetGrid: TCustomDBGridView;
  protected
    procedure Change; override;
    procedure SetCount(Value: Integer); override;
  public
    property Grid: TCustomDBGridView read GetGrid;
  published
    property AutoHeight;
    property Height;
  end;

{ TDBGridFixed }

  {
    ��������� ������������� ������� �������. ����� ������������� ��������
    DefCount - ���������� ������������� �������, �.�. �������� Count
    ������� �� ���������� ������� � ����� ���� �������� � 0 ���
    �������������� �������� ������� �������� �� ����� ��������� ������. 
  }

  TDBGridFixed = class(TCustomGridFixed)
  private
    FDefCount: Integer;
    function GetGrid: TCustomDBGridView;
    procedure SetDefCount(Value: Integer);
  public
    property Grid: TCustomDBGridView read GetGrid;
  published
    property Color;
    property Count: Integer read FDefCount write SetDefCount default 0;
    property Flat;
    property Font;
    property GridColor;
    property GridFont;
    property ShowDivider;
  end;

{ TDBGridScrollBar }

  {
    ����������� �������� �������. ����� ������� ������ 0, ����� ��
    ������������� ������ � TGridView. ��� ��������� �� ��������� ���������
    ������ ��������� � ����������� �� ������� ������ ���������. �����������
    ������� ��������� � ������� ������� ������ ��������� ������.
  }

  TDBGridScrollBar = class(TGridScrollBar)
  private
    FRowMin: Integer;
    FRowMax: Integer;
    function GetGrid: TCustomDBGridView;
  protected
    procedure ScrollMessage(var Message: TWMScroll); override;
    procedure SetParams(AMin, AMax, APageStep, ALineStep: Integer); override;
    procedure SetPositionEx(Value: Integer; ScrollCode: Integer); override;
    procedure Update; override;
  public
    property Grid: TCustomDBGridView read GetGrid;
  end;

{ TDBGridEdit }

  {
    ������ �������������� �������. ����� ���������� ���������� ������
    ��� Lookup �����. ������� ������ ������ ��� "...", ���� ���� �������
    ������ ������������� (ReadOnly, �����������, BLOB ���� � �.�.).
  }

  TDBGridListBox = class(TPopupDataList)
  private
    FLookupSource: TDataSource;
  public
    constructor Create(AOwner: TComponent); override;
    property LookupSource: TDataSource read FLookupSource;
  end;

  TDBGridEdit = class(TCustomGridEdit)
  private
    FDataList: TDBGridListBox;
    function GetGrid: TCustomDBGridView;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
  protected
    function GetDropList: TWinControl; override;
    procedure UpdateList; override;
    procedure UpdateListItems; override;
    procedure UpdateListValue(Accept: Boolean); override;
    procedure UpdateStyle; override;
  public
    property Grid: TCustomDBGridView read GetGrid;
  end;

{ TDBGridDataLink }

  {
    ������ ������� � ���������� ������. ������������� ������� ���������
    ��������� � �������� �� ��� ��������� �������.
  }

  TDBGridDataLink = class(TDataLink)
  private
    FGrid: TCustomDBGridView;
    FModified: Boolean;
    FInUpdateData: Integer;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure EditingChanged; override;
    procedure FocusControl(Field: TFieldRef); override;
    function GetActiveRecord: Integer; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure SetActiveRecord(Value: Integer); override;
    procedure UpdateData; override;
    property Grid: TCustomDBGridView read FGrid;
    property InUpdateData: Integer read FInUpdateData;
  public
    constructor Create(AGrid: TCustomDBGridView);
    procedure Modified;
    function MoveBy(Distance: Integer): Integer; override;
    procedure Reset;
  end;

{ TDBGridSelectedRows }

  TDBGridSelectedRows = class(TStringList)
  private
    FGrid: TCustomDBGridView;
    FCache: string;
    FCacheIndex: Integer;
    FCacheFind: Boolean;
    FSelectionMark: string;
    FSelecting: Boolean;
    function GetBookmark(Index: Integer): TBookmark;
    function GetCurrentRow: string;
    function GetCurrentRowSelected: Boolean;
    procedure SetCurrentRowSelected(Value: Boolean);
  protected
    procedure Changed; override;
    function CompareStrings(const S1, S2: string): Integer; override;
  public
    constructor Create(AGrid: TCustomDBGridView);
    procedure Clear; override;
    function Compare(const S1, S2: string): Integer;
    function Find(const S: string; var Index: Integer): Boolean; override;
    function IndexOf(const S: string): Integer; override;
    procedure UpdateSelectionMark;
    property Bookmarks[Index: Integer]: TBookmark read GetBookmark; default;
    property CurrentRow: string read GetCurrentRow;
    property CurrentRowSelected: Boolean read GetCurrentRowSelected write SetCurrentRowSelected;
    property SelectionMark: string read FSelectionMark;
    property Selecting: Boolean read FSelecting;
  end;

{ TCustomDBGridView }

  {
    ������� ��� ����������� ����������� ���������� ��������� ������.
    ��������� �����������, ����������� DBGrid: ����������� ������ ��
    ���������� DataSet, �������������� �������� ������� �� �����
    ���������, �������������� �������, ���������� ������ ������� ���
    lookup �����, ���������, ������� � �������� �������.

    ������:

    ChangeEditText -    �������� ������� �������� �������������� ����
                        � ����������� ������ ��������������. �����
                        ���������� ������ �������� ��������� �����������
                        �������������� ����. ������������, ����� ��������
                        ���� ��������� �������� ����� (��������, �����
                        ������� ������ ... (� �����������)).

    ��������:

    AllowInsertRecord - ����� �� ��������� ����� ������ � ������� ���
                        ������� ������� INSERT ��� �� ���������� �����
                        �������.
    AllowDeleteRecord - ����� �� ������� ������ �� ������� ��� �������
                        ������� DELETE;
    DataSource -        ������ � ���������� ������.
    DefaultLayout -     ������� �������������� ��������� ������� ������� �
                        ������������ � ������� ����� ��������� ������.
    EditColumn -        ������� ������������� �������. ������������
                        �������, � ������� ��������� ������ �����.
    EditField -         ������� ������������� ���� ���������. ������������
                        ���� ������� ������� ������������� ������.
    IndicatorImages -   ������ �� ������ �������� ����������. �� ���������
                        ����������� ����� ���������� ���������� � ��������
                        �������� ���������:
                          -1 - ��� ����������.
                           0 - ������� ������.
                           1 - ���� ��������������.
                           2 - ����� ������.
                           3 - ���������������.
                           4 - ���������������.
    IndicatorWidth -    ������ ������� ����������. ���� �������� ����� 0,
                        �� ������ ������������� ����������� ������ ������
                        ������ ��������� ��������������� ���������.
    SelectedField -     ������� ���������� ���� ���������. ������������
                        ���� ������� ������� ���������� ������.
    ShowIndicator -     ������� ����������� ����������.

    �������:

    ��� ����������� ������� ���������� �������� TGridView �� �����
    �����������: �������� ������ ������, ��������� � ������� (�.�. Cell.Row),
    ������ ���������� �� 0 �� ���������� ������� ��������. ��� ��������� ����
    (�������� ����) ��������� ������, ��������������� ��������� ������,
    ���������� ��������������� ��������� Columns[Cell.Col].Field.

    OnDataDeleteRecord -  ������ �� �������� ������ ������ ��������� ���
                          ������� ������� Delete.
    OnDataEditError -     ���������� ������ ������ �������������� ������
                          ���������.
    OnDataInsertRecord -  ������ �� ������� ������ � �������� ��� �������
                          ������� Insert.
    OnDataUpdateError -   ���������� ������ ���������� �������� ����
                          ��������� ��� ���������� ��������������.
    OnDataUpdateField -   ������� �� ��������� �������� �������� ����.
                          ���������� ����� ������ � ���� ������ �������� ��
                          ������ ����� (����������� ������).
    OnGetIndicatorImage - �������� ������ �������� ����������.
  }

  TDBGridDataAction = (gdaFail, gdaAbort);

  TDBGridDataErrorEvent = procedure(Sender: TObject; E: Exception; var Action: TDBGridDataAction) of object;
  TDBGridDataInsertEvent = procedure(Sender: TObject; var AllowInsert: Boolean) of object;
  TDBGridDataDeleteEvent = procedure(Sender: TObject; var AllowDelete: Boolean) of object;
  TDBGridDataUpdateEvent = procedure(Sender: TObject; Field: TField) of object;
  TDBGridTextEvent = procedure(Sender: TObject; Field: TField; const Text: string) of object;

  TDBGridIndicatorImageEvent = procedure(Sender: TObject; DataRow: Integer; var ImageIndex: Integer) of object;

  TCustomDBGridView = class(TCustomGridView)
  private
    FDataLink: TDBGridDataLink;
    FDefaultLayout: Boolean;
    FShowIndicator: Boolean;
    FIndicatorImages: TImageList;
    FIndicatorsLink: TChangeLink;
    FIndicatorsDef: TImageList;
    FIndicatorWidth: Integer;
    FAllowInsertRecord: Boolean;
    FAllowDeleteRecord: Boolean;
    FLayoutLock: Integer;
    FScrollLock: Integer;
    FScrollCell: TGridCell;
    FScrollSelected: Boolean;
    FCursorFromDataSet: Integer;
    FFieldText: string;
    FMultiSelect: Boolean;
    FSelectedRows: TDBGridSelectedRows;
    FContextPopup: Integer;
    FCancelOnDeactivate: Boolean;
    FOnDataChange: TNotifyEvent;
    FOnDataEditError: TDBGridDataErrorEvent;
    FOnDataUpdateError: TDBGridDataErrorEvent;
    FOnDataInsertRecord: TDBGridDataInsertEvent;
    FOnDataDeleteRecord: TDBGridDataDeleteEvent;
    FOnDataUpdateField: TDBGridDataUpdateEvent;
    FOnSetFieldText: TDBGridTextEvent;
    FOnGetIndicatorImage: TDBGridIndicatorImageEvent;
    function GetCol: Longint;
    function GetColumns: TDBGridColumns;
    function GetEditColumn: TDBGridColumn;
    function GetEditField: TField;
    function GetFixed: TDBGridFixed;
    function GetHeader: TDBGridHeader;
    function GetRows: TDBGridRows;
    function GetSelectedField: TField;
    function GetSelectedRows: TDBGridSelectedRows;
    procedure IndicatorsChange(Sender: TObject);
    function IsColumnsStored: Boolean;
    procedure SetCol(Value: Longint);
    procedure SetColumns(Value: TDBGridColumns);
    procedure SetDataSource(Value: TDataSource);
    procedure SetDefaultLayout(Value: Boolean);
    procedure SetFixed(Value: TDBGridFixed);
    procedure SetHeader(Value: TDBGridHeader);
    procedure SetIndicatorImages(Value: TImageList);
    procedure SetIndicatorWidth(Value: Integer);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetRows(Value: TDBGridRows);
    procedure SetSelectedField(Value: TField);
    procedure SetShowIndicator(Value: Boolean);
    procedure ReadColumns(Reader: TReader);
    procedure WriteColumns(Writer: TWriter);
    procedure CMExit(var Message: TMessage); message CM_EXIT;
    procedure WMContextMenu(var Message: TMessage); message WM_CONTEXTMENU;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    FSelectPending: Boolean;
    FSelectPos: TPoint;
    FSelectShift: TShiftState;
    function AcquireLockLayout: Boolean;
    procedure CancelOrUpdateData;
    procedure ChangeIndicator; virtual;
    procedure ChangeScale(M, D: Integer); override;
    function CreateColumns: TGridColumns; override;
    function CreateDataLink: TDBGridDataLink; virtual;
    function CreateFixed: TCustomGridFixed; override;
    function CreateHeader: TCustomGridHeader; override;
    function CreateRows: TCustomGridRows; override;
    function CreateScrollBar(Kind: TScrollBarKind): TGridScrollBar; override;
    procedure DataEditError(E: Exception; var Action: TDBGridDataAction); virtual;
    procedure DataFieldUpdated(Field: TField); virtual;
    procedure DataLayoutChanged; virtual;
    procedure DataLinkActivate(Active: Boolean); virtual;
    procedure DataRecordChanged(Field: TField); virtual;
    procedure DataSetChanged; virtual;
    procedure DataSetScrolled(Distance: Integer); virtual;
    procedure DataUpdateError(E: Exception; var Action: TDBGridDataAction); virtual;
    procedure DefineProperties(Filer: TFiler); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function EditCanAcceptKey(Cell: TGridCell; Key: Char): Boolean; override;
    function EditCanModify(Cell: TGridCell): Boolean; override;
    function EditCanShow(Cell: TGridCell): Boolean; override;
    procedure GetCellColors(Cell: TGridCell; Canvas: TCanvas); override;
    function GetCellText(Cell: TGridCell): string; override;
    function GetColumnClass: TGridColumnClass; override;
    function GetDataSource: TDataSource; virtual;
    function GetEditClass(Cell: TGridCell): TGridEditClass; override;
    function GetEditText(Cell: TGridCell): string; override;
    procedure HideCursor; override;
    procedure InvalidateIndicator;
    procedure InvalidateIndicatorImage(DataRow: Integer);
    procedure InvalidateSelected;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MoveBy(Distance: Integer; Shift: TShiftState);
    procedure MoveByXY(X, Y: Integer; Shift: TShiftState);
    procedure MoveTo(RecNo: Integer; Shift: TShiftState);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PaintCell(Cell: TGridCell; Rect: TRect); override;
    procedure PaintIndicatorFixed; virtual;
    procedure PaintIndicatorGridLines; virtual;
    procedure PaintIndicatorHeader; virtual;
    procedure PaintIndicatorImage(Rect: TRect; DataRow: Integer); virtual;
    procedure SetEditText(Cell: TGridCell; var Value: string); override;
    procedure SetFieldText(Field: TField; const Text: string); virtual;
    procedure Resize; override;
    procedure ShowCursor; override;
    procedure UpdateData; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyEdit; override;
    procedure CancelEdit; override;
    procedure ChangeEditText(const S: string); virtual;
    procedure Delete; virtual;
    function FindText(const FindText: string; Options: TFindOptions): Boolean; override;
    function GetGridRect: TRect; override;
    function GetHeaderRect: TRect; override;
    function GetIndicatorHeaderRect: TRect; virtual;
    function GetIndicatorFixedRect: TRect; virtual;
    function GetIndicatorImage(DataRow: Integer): Integer; virtual;
    function GetIndicatorImageRect(DataRow: Integer): TRect; virtual;
    function GetIndicatorWidth: Integer;
    procedure InvalidateGrid; override;
    procedure InvalidateRow(Row: Integer); override;
    procedure Insert(AppendMode: Boolean); virtual;
    function IsCellReadOnly(Cell: TGridCell): Boolean; override;
    function IsEvenRow(Cell: TGridCell): Boolean; override;
    function IsRowHighlighted(Row: Integer): Boolean; override;
    function IsRowMultiselected(Row: Integer): Boolean;
    procedure LockLayout;
    procedure LockScroll;
    procedure MakeCellVisible(Cell: TGridCell; PartialOK: Boolean); override;
    procedure SelectAll;
    procedure SetCursor(Cell: TGridCell; Selected, Visible: Boolean); override;
    procedure UndoEdit; override;
    procedure UnLockLayout(CancelChanges: Boolean);
    procedure UnLockScroll(CancelScroll: Boolean);
    procedure UpdateCursorPos(ShowCursor: Boolean); virtual;
    procedure UpdateEditText; override;
    procedure UpdateLayout; virtual;
    procedure UpdateRowCount; virtual;
    procedure UpdateSelection(var Cell: TGridCell; var Selected: Boolean); override;
    property AllowDeleteRecord: Boolean read FAllowDeleteRecord write FAllowDeleteRecord default True;
    property AllowEdit default True;
    property AllowInsertRecord: Boolean read FAllowInsertRecord write FAllowInsertRecord default True;
    property CancelOnDeactivate: Boolean read FCancelOnDeactivate write FCancelOnDeactivate default False;
    property Col: Longint read GetCol write SetCol;
    property ColumnClick default False;
    property Columns: TDBGridColumns read GetColumns write SetColumns stored IsColumnsStored;
    property CursorKeys default [gkArrows, gkTabs, gkMouse, gkMouseWheel];
    property CursorLock: Integer read FScrollLock;
    property DataLink: TDBGridDataLink read FDataLink;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DefaultLayout: Boolean read FDefaultLayout write SetDefaultLayout default True;
    property Header: TDBGridHeader read GetHeader write SetHeader;
    property Fixed: TDBGridFixed read GetFixed write SetFixed; { <- ����� Header !!! }
    property LayoutLock: Integer read FLayoutLock;
    property EditColumn: TDBGridColumn read GetEditColumn;
    property EditField: TField read GetEditField;
    property IndicatorImages: TImageList read FIndicatorImages write SetIndicatorImages;
    property IndicatorWidth: Integer read FIndicatorWidth write SetIndicatorWidth default 0;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property Rows: TDBGridRows read GetRows write SetRows;
    property SelectedField: TField read GetSelectedField write SetSelectedField;
    property SelectedRows: TDBGridSelectedRows read GetSelectedRows;
    property ShowIndicator: Boolean read FShowIndicator write SetShowIndicator default True;
    property OnDataChange: TNotifyEvent read FOnDataChange write FOnDataChange;
    property OnDataDeleteRecord: TDBGridDataDeleteEvent read FOnDataDeleteRecord write FOnDataDeleteRecord;
    property OnDataInsertRecord: TDBGridDataInsertEvent read FOnDataInsertRecord write FOnDataInsertRecord;
    property OnDataEditError: TDBGridDataErrorEvent read FOnDataEditError write FOnDataEditError;
    property OnDataUpdateError: TDBGridDataErrorEvent read FOnDataUpdateError write FOnDataUpdateError;
    property OnDataUpdateField: TDBGridDataUpdateEvent read FOnDataUpdateField write FOnDataUpdateField;
    property OnGetIndicatorImage: TDBGridIndicatorImageEvent read FOnGetIndicatorImage write FOnGetIndicatorImage;
    property OnSetFieldText: TDBGridTextEvent read FOnSetFieldText write FOnSetFieldText;
  end;

  TDBGridView = class(TCustomDBGridView)
  published
    property Align;
    property AllowDeleteRecord;
    property AllowEdit;
    property AllowInsertRecord;
    property AllowSelect;
    property AlwaysEdit;
    property AlwaysSelected;
    property Anchors;
    property BorderStyle;
    property CancelOnExit;
    property CancelOnDeactivate;
    property CheckBoxes;
    property CheckStyle;
    property Color;
    property ColumnClick;
    property Columns;
    property ColumnsFullDrag;
    property Constraints;
    property Ctl3D;
    property CursorKeys;
    property DataSource;
    property DefaultEditMenu;
    property DefaultHeaderMenu;
    property DefaultLayout;
    property DragCursor;
    property DragMode;
    property DoubleBuffered default True;
    property Enabled;
    property EndEllipsis;
    property Fixed;
    property FlatBorder;
    property FocusOnScroll;
    property Font;
    property GrayReadOnly;
    property GridColor;
    property GridHint;
    property GridHintColor;
    property GridLines;
    property GridStyle;
    property Header;
    property HideSelection;
    property HighlightEvenRows;
    property HighlightFocusCol;
    property HighlightFocusRow;
    property Hint;
    property HorzScrollBar;
    property ImageIndexDef;
    property ImageHighlight;
    property Images;
    property IndicatorImages;
    property IndicatorWidth;
    property MultiSelect;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property Rows;
    property RowSelect;
    property ShowCellTips;
    property ShowIndicator;
    property ShowFocusRect;
    property ShowGridHint;
    property ShowHeader;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property VertScrollBar;
    property Visible;
    property OnCellAcceptCursor;
    property OnCellClick;
    property OnCellTips;
    property OnChange;
    property OnChangeColumns;
    property OnChangeEditing;
    property OnChangeEditMode;
    property OnChangeFixed;
    property OnChangeRows;
    property OnChanging;
    property OnCheckClick;
    property OnClick;
    property OnColumnAutoSize;
    property OnColumnResizing;
    property OnColumnResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDataChange;
    property OnDataDeleteRecord;
    property OnDataEditError;
    property OnDataInsertRecord;
    property OnDataUpdateField;
    property OnDataUpdateError;
    property OnDragDrop;
    property OnDragOver;
    property OnDraw;
    property OnDrawCell;
    property OnDrawHeader;
    property OnEditAcceptKey;
    property OnEditButtonPress;
    property OnEditCanceled;
    property OnEditCanModify;
    property OnEditChange;
    property OnEditCloseUp;
    property OnEditCloseUpEx;
    property OnEditSelectNext;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCellColors;
    property OnGetCellImage;
    property OnGetCellImageEx;
    property OnGetCellImageIndent;
    property OnGetCellHintRect;
    property OnGetCellReadOnly;
    property OnGetCellText;
    property OnGetCellTextIndent;
    property OnGetCheckAlignment;
    property OnGetCheckImage;
    property OnGetCheckIndent;
    property OnGetCheckKind;
    property OnGetCheckState;
    property OnGetCheckStateEx;
    property OnGetEditList;
    property OnGetEditListBounds;
    property OnGetEditListIndex;
    property OnGetEditMask;
    property OnGetEditStyle;
    property OnGetEditText;
    property OnGetGridHint;
    property OnGetGridColor;
    property OnGetHeaderColors;
    property OnGetHeaderImage;
    property OnGetIndicatorImage;
    property OnGetSortDirection;
    property OnGetSortImage;
    property OnGetTipsRect;
    property OnGetTipsText;
    property OnHeaderClick;
    property OnHeaderClicking;
    property OnHeaderDetailsClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnResize;
    property OnSetEditText;
    property OnSetFieldText;
    property OnStartDrag;
  end;

{ ��������� ������ ��� ������ � ���������� }

function StrToBookmark(const S: string): TBookmark;
function BookmarkToStr(const Bookmark: TBookmark): string;

implementation

uses
  Themes, DBConsts;

{$R *.RES}

{ TDBGridHeader }

constructor TDBGridHeader.Create(AGrid: TCustomGridView);
begin
  inherited;
  FullSynchronizing := False;
end;

{ TDBGridColumn }

constructor TDBGridColumn.Create(Collection: TCollection);
begin
  inherited;
  FDefaultColumn := True;
end;

procedure TDBGridColumn.Assign(Source: TPersistent);
begin
  if Source is TDBGridColumn then
  begin
    FieldName := TDBGridColumn(Source).FieldName;
    DefaultColumn := TDBGridColumn(Source).DefaultColumn;
  end;
  inherited Assign(Source);
end;

function TDBGridColumn.IsNondefaultColumn: Boolean;
begin
  Result := not DefaultColumn;
end;

function TDBGridColumn.GetField: TField;
begin
  if (FField = nil) and (Length(FFieldName) > 0) then
    if Assigned(Grid) and Assigned(Grid.DataLink.DataSet) then
      with Grid.Datalink.Dataset do
        if Active or (lcPersistent in Fields.LifeCycles) then
          SetField(FindField(FFieldName));
  Result := FField;
end;

function TDBGridColumn.GetGrid: TCustomDBGridView;
begin
  Result := TCustomDBGridView(inherited Grid);
end;

procedure TDBGridColumn.SetDefaultColumn(Value: Boolean);
begin
  if FDefaultColumn <> Value then
  begin
    if Value then RestoreDefaults;
    FDefaultColumn := Value;
  end;
end;

procedure TDBGridColumn.SetField(Value: TField);
begin
  if FField <> Value then
  begin
    if (FField <> nil) and (Grid <> nil) then FField.RemoveFreeNotification(Grid);
    FField := Value;
    if FField <> nil then
    begin
      if Grid <> nil then FField.FreeNotification(Grid);
      FFieldName := FField.FullName;
    end;
  end;
end;

procedure TDBGridColumn.SetFieldName(const Value: string);
var
  AField: TField;
begin
  AField := nil;
  if Length(Value) > 0 then
    if Assigned(Grid) and (not (csLoading in Grid.ComponentState)) then
      if Assigned(Grid.DataLink.DataSet) then
        AField := Grid.DataLink.DataSet.FindField(Value);
  FFieldName := Value;
  SetField(AField);
  { ��������������� �������� �� ��������� }
  if FDefaultColumn then
  begin
    RestoreDefaults;
    FDefaultColumn := True;
  end;
  { ������� �������� }
  Changed(False);
end;

function TDBGridColumn.GetDisplayName: string;
begin
  Result := FFieldName;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure TDBGridColumn.SetAlignment(Value: TAlignment);
begin
  FDefaultColumn := False;
  inherited;
end;

procedure TDBGridColumn.SetCaption(const Value: string);
begin
  FDefaultColumn := False;
  inherited;
end;

procedure TDBGridColumn.SetEditMask(const Value: string);
begin
  FDefaultColumn := False;
  inherited;
end;

procedure TDBGridColumn.SetEditStyle(Value: TGRidEditStyle);
begin
  FDefaultColumn := False;
  inherited;
end;

procedure TDBGridColumn.SetMaxLength(Value: Integer);
begin
  FDefaultColumn := False;
  inherited;
end;

procedure TDBGridColumn.SetReadOnly(Value: Boolean);
begin
  FDefaultColumn := False;
  inherited;
end;

procedure TDBGridColumn.SetWidth(Value: Integer);
begin
  if FWidthLock = 0 then FDefaultColumn := False;
  inherited;
end;

function IsLookupField(Field: TField): Boolean;
var
  MasterField: TField;
begin
  Result := False;
  if (Field <> nil) and (Field.FieldKind = fkLookup) and (Field.DataSet <> nil) then
  begin
    MasterField := Field.DataSet.FieldByName(Field.KeyFields);
    if (MasterField <> nil) and MasterField.CanModify then Result := True;
  end
end;

function IsReadOnlyField(Field: TField): Boolean;
const
  fkReadOnly = [fkLookup, fkCalculated];
begin
  Result := (Field = nil) or Field.ReadOnly or (Field.FieldKind in fkReadOnly) or
    ((Field.DataType in ftNonTextTypes) and (not Assigned(Field.OnSetText)));
end;

procedure TDBGridColumn.RestoreDefaults;
var
  R: TRect;

  function AllowLookup: Boolean;
  begin
    Result := IsLookupField(Field) and (Grid <> nil) and
      (Grid.DataLink.Active) and (not Grid.Datalink.ReadOnly);
  end;

begin
  if Field <> nil then
  begin
    Alignment := Field.Alignment;
    Caption := Field.DisplayLabel;
    EditMask := Field.EditMask;
    { ��� ������ ��� Lookup ����� }
    if AllowLookup then EditStyle := geDataList
    else if PickListCount > 0 then EditStyle := gePickList
    else EditStyle := geSimple;
    { ����������� �������������� � ������������ ����� ������ }
    ReadOnly := IsReadOnlyField(Field);
    MaxLength := 0;
    if Field.DataType in [ftString, ftWideString] then MaxLength := Field.Size;
    { ������ ������� �� ����� ���� }
    if Grid <> nil then
    begin
      Grid.GetCellColors(GridCell(Self.Index, 0), Grid.Canvas);
      Width := Grid.GetFontWidth(Grid.Canvas.Font, Field.DisplayWidth);
      { �� �������� � DBGrid ������ ������� (�.�. ������ �� ���������,
        �.�. �������� Width ���������� 0 ��� ��������� �������) ������ ����
        �����, ����� � ��������� ��������� �������� ������� }
      with Grid do
        R := GetTextRect(Canvas, Rect(0, 0, 0, 0), TextLeftIndent, TextTopIndent,
          Self.Alignment, False, False, Self.Caption);
      Width := MaxIntValue([DefWidth, R.Right - R.Left]);
    end;
  end;
end;

{ TDBGridColumns }

function TDBGridColumns.GetColumn(Index: Integer): TDBGridColumn;
begin
  Result := TDBGridColumn(inherited GetItem(Index));
end;

function TDBGridColumns.GetGrid: TCustomDBGridView;
begin
  Result := TCustomDBGridView(inherited Grid);
end;

procedure TDBGridColumns.SetColumn(Index: Integer; Value: TDBGridColumn);
begin
  inherited SetItem(Index, Value);
end;

procedure TDBGridColumns.Update(Item: TCollectionItem);
begin
  if (Grid <> nil) and (Grid.LayoutLock = 0) {and (not Grid.ColResizing) }then Grid.DefaultLayout := False;
  inherited;
end;

function TDBGridColumns.Add: TDBGridColumn;
begin
  Result := TDBGridColumn(inherited Add);
end;

{ TDBGridListBox }

constructor TDBGridListBox.Create(AOwner: TComponent);
begin
  inherited;
  FLookupSource := TDataSource.Create(Self);
end;

{ TDBGridEdit }

function TDBGridEdit.GetGrid: TCustomDBGridView;
begin
  Result := TCustomDBGridView(inherited Grid);
end;

function TDBGridEdit.GetDropList: TWinControl;
begin
  if (EditStyle = geDataList) and (Grid <> nil) and IsLookupField(Grid.EditField) then
  begin
    if FDataList = nil then FDataList := TDBGridListBox.Create(Self);
    Result := FDataList;
  end
  else
    Result := inherited GetDropList;
end;

procedure TDBGridEdit.UpdateList;
begin
  inherited;
  if (ActiveList = nil) or (not (ActiveList is TDBGridListBox)) then Exit;
  { ����������� ���������� ����� ����������� lookup ������ }
  TDBGridListBox(ActiveList).RowCount := Self.DropDownCount;
end;

procedure TDBGridEdit.UpdateListItems;
begin
  if (ActiveList = nil) or (not (ActiveList is TDBGridListBox)) then
  begin
    inherited;
    Exit;
  end;
  { ��������� ������� � ������� ���� }
  if (Grid = nil) or (Grid.EditField = nil) then Exit;
  { ����������� lookup ������ }
  with Grid.EditField, TDBGridListBox(ActiveList) do
  begin
    LookupSource.DataSet := LookupDataSet;
    KeyField := LookupKeyFields;
    ListField := LookupResultField;
    ListSource := LookupSource;
    KeyValue := DataSet.FieldByName(KeyFields).Value;
  end;
end;

procedure TDBGridEdit.UpdateListValue(Accept: Boolean);
var
  ListValue: Variant;
  MasterField: TField;
begin
  if (ActiveList <> nil) and Accept and (Grid <> nil) then
  begin
    { DataList � PickList �������������� ������ �� ������ }
    if ActiveList is TDBGridListBox then
      { lookup ������ }
      with TDBGridListBox(ActiveList) do
      begin
        ListValue := KeyValue;
        ListSource := nil;
        LookupSource.DataSet := nil;
        if (Grid.EditField <> nil) and (Grid.EditField.DataSet <> nil) then
          with Grid.EditField do
          begin
            MasterField := DataSet.FindField(KeyFields);
            if (MasterField <> nil) and MasterField.CanModify and Grid.DataLink.Edit then
              MasterField.Value := ListValue;
          end;
      end
    else if ActiveList is TGridListBox then
      { ���������� ������  }
      if EditCanModify then
      begin
        inherited;
        Grid.DataLink.Modified;
      end;
  end
  else
    inherited;
end;

procedure TDBGridEdit.UpdateStyle;
var
  MasterField: TField;
begin
  inherited UpdateStyle;
  { ���� ������ ����� ������ (������ ��� � �����������), � ��������������
    ���������� ������ ������, �� ������ ������� }
  if (EditStyle <> geSimple) and (Grid <> nil) then
    { ��������� ���������� ��������� }
    if (not Grid.DataLink.Active) or Grid.DataLink.ReadOnly then
      EditStyle := geSimple
    { ���������, ����� �� �������� �������� }
    else if (Grid.DataLink.DataSet <> nil) and (not Grid.DataLink.DataSet.CanModify) then
      EditStyle := geSimple
    { ���� ��� lookup �� ������� Master ���� ��� ��� ������ ��������, ��
      ������ ���� ������� }
    else if EditStyle = geDataList then
    begin
      { ���� ������-���� }
      MasterField := nil;
      if (Grid.EditField <> nil) and (Grid.EditField.DataSet <> nil) then
        with Grid.EditField do MasterField := DataSet.FindField(KeyFields);
      { ��������� ��� }
      if (MasterField = nil) or (not MasterField.CanModify) then EditStyle := geSimple;
    end
    else if Grid.IsCellReadOnly(Grid.EditCell) then
      { PickList ��� ReadOnly ������ �� ����� }
      EditStyle := geSimple;
end;

procedure TDBGridEdit.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  { ���������� ������� ������ ������ ��� �������, ����� �� ����� ���������
    ������ �������� �� ����������� ������ ������������ ������, ��������,
    ������ ������ ����� "������..." }
  if ClosingUp or Pressing then Exit;
  { ���� �������� �����, �� �������� ��������� �������������� ������ �
    ������ ������ �� ������ ����� � DataSet, ��� ��� ������ TTreeView }
  if (Grid <> nil) and Grid.CancelOnDeactivate and IsWindowVisible(Handle) then
  try
    Grid.CancelOrUpdateData;
  except
    Application.HandleException(Self);
  end;
end;

{ TDBGridRows }

function TDBGridRows.GetGrid: TCustomDBGridView;
begin
  Result := TCustomDBGridView(inherited Grid);
end;

procedure TDBGridRows.Change;
begin
  { ��� ��������� ������ ����� ���������� �������� ���������� �������
    ����� ������� }
  if Grid <> nil then Grid.UpdateRowCount;
  inherited;
end;

procedure TDBGridRows.SetCount(Value: Integer);
begin
  { ������ ���������� ����� ����� ������ ������� }
  if FRowsFromGrid <> 0 then inherited;
end;

{ TDBGridFixed }

function TDBGridFixed.GetGrid: TCustomDBGridView;
begin
  Result := TCustomDBGridView(inherited Grid);
end;

procedure TDBGridFixed.SetDefCount(Value: Integer);
begin
  FDefCount := Value;
  SetCount(Value);
end;

{ TDBGridScrollBar }

function TDBGridScrollBar.GetGrid: TCustomDBGridView;
begin
  Result := TCustomDBGridView(inherited Grid);
end;

procedure TDBGridScrollBar.ScrollMessage(var Message: TWMScroll);
var
  ScrollInfo: TScrollInfo;
  DataSet: TDataSet;
  PageStep: Integer;
  Shift: TShiftState;

  procedure DoThumbPos(Pos: Integer);
  begin
    if DataSet.IsSequenced then
    begin
      { ���������� ������� �������� - ������ ����� �� ��������� ������ }
      if Pos <= 1 then Grid.MoveBy(DBGRID_BOF, Shift)
      else if Pos >= DataSet.RecordCount then Grid.MoveBy(DBGRID_EOF, Shift)
      else Grid.MoveTo(Pos, Shift);
    end
    else
      { ���������� ������� �� �������� - ������ ���������� }
      case Pos of
        0: Grid.MoveBy(DBGRID_BOF, Shift);
        1: Grid.MoveBy(-PageStep, Shift);
        2: Exit;
        3: Grid.MoveBy(PageStep, Shift);
        4: Grid.MoveBy(DBGRID_EOF, Shift);
      end;
  end;

begin
  { ��������� �������� }
  if (Grid = nil) or (not Grid.DataLink.Active) or (Grid.DataLink.DataSet = nil) then Exit;
  { �������� ������� ������� }
  FillChar(ScrollInfo, SizeOf(ScrollInfo), 0);
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  ScrollInfo.fMask := SIF_TRACKPOS;
  if not GetScrollInfo(Grid.Handle, FBarCode, ScrollInfo) then
  begin
    inherited;
    Exit;
  end;
  { ������������ ��������� }
  DataSet := Grid.DataLink.DataSet;
  PageStep := Grid.VisSize.Row;
  Shift := KeyboardStateToShiftState - [ssShift];
  case Message.ScrollCode of
    SB_LINEUP: Grid.MoveBy(-1, Shift);
    SB_LINEDOWN: Grid.MoveBy(1, Shift);
    SB_PAGEUP: Grid.MoveBy(-PageStep, Shift);
    SB_PAGEDOWN: Grid.MoveBy(PageStep, Shift);
    SB_THUMBPOSITION: DoThumbPos(ScrollInfo.nTrackPos);
    SB_THUMBTRACK: if Tracking and DataSet.IsSequenced then DoThumbPos(ScrollInfo.nTrackPos);
    SB_BOTTOM: Grid.MoveBy(DBGRID_EOF, Shift);
    SB_TOP: Grid.MoveBy(DBGRID_BOF, Shift);
  end;
end;

procedure TDBGridScrollBar.SetParams(AMin, AMax, APageStep, ALineStep: Integer);
begin
  inherited SetParams(0, 0, 0, 0);
  Update;
end;

procedure TDBGridScrollBar.SetPositionEx(Value: Integer; ScrollCode: Integer);
begin
  inherited SetPositionEx(0, ScrollCode);
  Update;
end;

procedure TDBGridScrollBar.Update;
var
  NewPage, NewPos: Integer;
  DataSet: TDataSet;
  SI: TScrollInfo;
begin
  if (Grid <> nil) and (Grid.HandleAllocated) and (UpdateLock = 0) then
  begin
    { ��������� ��������� � ����������� �� ��������� ��������� ������ }
    NewPage := 0;
    NewPos := 0;
    DataSet := Grid.DataLink.DataSet;
    if Grid.DataLink.Active and (DataSet <> nil) then
    begin
      { ��� ���������� ������, � ������� ����������������� ��������
        (�������� Paradox) �������� ������������� �� ����� ������� ������,
        � ��� ���������� � ����������� ����������� ������� (SQL Server)
        �������� ������������� ��� �������� ����� � ���� �� ��������� }
      if DataSet.IsSequenced then
      begin
        { ���� ���� ������� ������, �� ������ �� ��� ������� �� ����
          (��������� ������� �������), ����� - ������ �� ������� ������ }
        if not (DataSet.State in [dsInactive, dsBrowse, dsEdit]) then
        begin
          SI.cbSize := SizeOf(SI);
          SI.fMask := SIF_ALL;
          GetScrollInfo(Grid.Handle, SB_VERT, SI);
          NewPos := SI.nPos;
        end
        else
          NewPos := DataSet.RecNo;
        { ��� �������� � ��������� ����� ����� ������ � ��������� ������ }
        FRowMin := 1;
        NewPage := Grid.VisSize.Row;
        FRowMax := DataSet.RecordCount + NewPage - 1;
      end
      else
      begin
        FRowMin := 0;
        FRowMax := 4;
        NewPage := 0;
        if DataSet.BOF then NewPos := 0
        else if DataSet.EOF then NewPos := 4
        else NewPos := 2;
      end;
    end
    else
    begin
      FRowMin := 0;
      FRowMax := 0;
    end;
    { ��������� ��������� ��� ��������� ���������� }
    FillChar(SI, SizeOf(SI), 0);
    SI.cbSize := SizeOf(SI);
    SI.fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
    if FRowMax <> FRowMin then 
    begin
      SI.nMin := FRowMin;
      SI.nMax := FRowMax;
      SI.nPage := NewPage;
      SI.nPos := NewPos;
    end;
    { ������������� ��������� }
    SetScrollInfo(Grid.Handle, SB_VERT, SI, True);
  end;
end;

{ TDBGridDataLink }

constructor TDBGridDataLink.Create(AGrid: TCustomDBGridView);
begin
  inherited Create;
  VisualControl := True;
  FGrid := AGrid;
end;

procedure TDBGridDataLink.ActiveChanged;
begin
  Grid.DataLinkActivate(Active);
  FModified := False;
end;

procedure TDBGridDataLink.DataSetChanged;
begin
  FGrid.DataSetChanged;
  FModified := False;
end;

procedure TDBGridDataLink.DataSetScrolled(Distance: Integer);
begin
  FGrid.DataSetScrolled(Distance);
end;

function TDBGridDataLink.GetActiveRecord: Integer;
begin                                                         
  Result := 0;
  { ����������� TDataLink ������-�� �� ���������, � ���� �� � ����
    �������� ������ ��� ��� }
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    Result := inherited GetActiveRecord;
end;

procedure TDBGridDataLink.LayoutChanged;
begin
  FGrid.DataLayoutChanged;
  inherited;
end;

procedure TDBGridDataLink.EditingChanged;
begin
  FGrid.InvalidateIndicatorImage(FGrid.Row);
  { ���� �������������� �����������, �� ����� ������ ����� }
  if not Editing then FGrid.HideEdit;
end;

procedure TDBGridDataLink.FocusControl(Field: TFieldRef);
begin
  if Assigned(Field) and Assigned(Field^) then
  begin
    FGrid.SelectedField := Field^;
    if (FGrid.SelectedField = Field^) and FGrid.AcquireFocus then
    begin
      Field^ := nil;
      FGrid.ShowEdit;
    end;
  end;
end;

function TDBGridDataLink.MoveBy(Distance: Integer): Integer;
begin
  Result := Distance;
  if Result <> 0 then Result := inherited MoveBy(Distance);
end;

procedure TDBGridDataLink.RecordChanged(Field: TField);
begin
  FGrid.DataRecordChanged(Field);
  FModified := False;
end;

procedure TDBGridDataLink.SetActiveRecord(Value: Integer);
begin
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    inherited;
end;

procedure TDBGridDataLink.UpdateData;
begin
  if FModified and (FInUpdateData = 0) then
  begin
    Inc(FInUpdateData);
    try
      FGrid.UpdateData;
    finally
      Dec(FInUpdateData);
    end;
    FModified := False;
  end;
end;

procedure TDBGridDataLink.Modified;
begin
  FModified := True;
end;

procedure TDBGridDataLink.Reset;
begin
  if FModified then RecordChanged(nil) else Dataset.Cancel;
end;

{ TDBGridSelectedRows }

function StrToBookmark(const S: string): TBookmark;
begin
  Result := BytesOf(S);
end;

function BookmarkToStr(const Bookmark: TBookmark): string;
begin
  Result := StringOf(Bookmark);
end;

constructor TDBGridSelectedRows.Create(AGrid: TCustomDBGridView);
begin
  inherited Create;
  FGrid := AGrid;
end;

procedure TDBGridSelectedRows.Changed;
begin
  inherited;
  FCache := '';
  FCacheIndex := -1;
end;

procedure TDBGridSelectedRows.Clear;
begin
  if Count > 0 then
  begin
    inherited Clear;
    FSelecting := False;
    FGrid.InvalidateGrid;
  end;
end;

function TDBGridSelectedRows.Compare(const S1, S2: string): Integer;
var
  Bookmark1, Bookmark2: TBookmark;
begin
  Bookmark1 := StrToBookmark(S1);
  Bookmark2 := StrToBookmark(S2);
  Result := FGrid.DataLink.DataSet.CompareBookmarks(Bookmark1, Bookmark2);
end;

function TDBGridSelectedRows.CompareStrings(const S1, S2: string): Integer;
begin
  Result := Compare(S1, S2);
end;

function TDBGridSelectedRows.Find(const S: string; var Index: Integer): Boolean;
begin
  if (S = FCache) and (FCacheIndex >= 0) then
  begin
    Index := FCacheIndex;
    Result := FCacheFind;
    Exit;
  end;
  Result := inherited Find(S, Index);
  FCache := S;
  FCacheIndex := Index;
  FCacheFind := Result;
end;

function TDBGridSelectedRows.GetBookmark(Index: Integer): TBookmark;
begin
  Result := StrToBookmark(inherited Get(Index));
end;

function TDBGridSelectedRows.GetCurrentRow: string;
begin
  Result := BookmarkToStr(FGrid.DataLink.DataSet.Bookmark);
end;

function TDBGridSelectedRows.GetCurrentRowSelected: Boolean;
begin
  Result := IndexOf(CurrentRow) <> -1;
end;

function TDBGridSelectedRows.IndexOf(const S: string): Integer;
begin
  if not Find(S, Result) then Result := -1;
end;

procedure TDBGridSelectedRows.SetCurrentRowSelected(Value: Boolean);
var
  Index: Integer;
  Current: string;
begin
  Current := CurrentRow;
  if Find(Current, Index) = Value then Exit;
  if Value then
    inherited Insert(Index, Current)
  else
    inherited Delete(Index);
end;

procedure TDBGridSelectedRows.UpdateSelectionMark;
begin
  FSelectionMark := CurrentRow;
  FSelecting := True;
end;

{ TCustomDBGridView }

constructor TCustomDBGridView.Create(AOwner: TComponent);
begin
  FDataLink := CreateDataLink;
  FDefaultLayout := True;
  FShowIndicator := True;
  FIndicatorsLink := TChangeLink.Create;
  FIndicatorsLink.OnChange := IndicatorsChange;
  FIndicatorsDef := TImageList.CreateSize(16, 16);
  FIndicatorsDef.BkColor := clFuchsia;
  FIndicatorsDef.ResInstLoad(HInstance, rtBitmap, 'BM_GRIDVIEW_DB', clFuchsia);
  FAllowDeleteRecord := True;
  FAllowInsertRecord := True;
  FSelectedRows := TDBGridSelectedRows.Create(Self);
  inherited;
  AllowEdit := True;
  ColumnClick := False;
  CursorKeys := [gkArrows, gkMouse, gkTabs, gkMouseWheel];
  DoubleBuffered := True;
end;

destructor TCustomDBGridView.Destroy;
begin
  inherited;
  FreeAndNil(FSelectedRows);
  FreeAndNil(FIndicatorsLink);
  FreeAndNil(FIndicatorsDef);
  FreeAndNil(FDataLink);
end;

function TCustomDBGridView.GetCol: Longint;
begin
  Result := inherited Col;
end;

function TCustomDBGridView.GetColumns: TDBGridColumns;
begin
  Result := TDBGridColumns(inherited Columns);
end;

function TCustomDBGridView.GetDataSource: TDataSource;
begin
  Result := DataLink.DataSource;
end;

function TCustomDBGridView.GetEditColumn: TDBGridColumn;
begin
  Result := TDBGridColumn(inherited EditColumn);
end;

function TCustomDBGridView.GetEditField: TField;
begin
  Result := nil;
  if EditColumn <> nil then Result := EditColumn.Field;
end;

function TCustomDBGridView.GetFixed: TDBGridFixed;
begin
  Result := TDBGridFixed(inherited Fixed);
end;

function TCustomDBGridView.GetHeader: TDBGridHeader;
begin
  Result := TDBGridHeader(inherited Header);
end;

function TCustomDBGridView.GetRows: TDBGridRows;
begin
  Result := TDBGridRows(inherited Rows);
end;

function TCustomDBGridView.GetSelectedField: TField;
begin
  Result := nil;
  if (Col >= Fixed.Count) and (Col < Columns.Count) then Result := Columns[Col].Field;
end;

function TCustomDBGridView.GetSelectedRows: TDBGridSelectedRows;
begin
  Result := FSelectedRows;
end;

procedure TCustomDBGridView.IndicatorsChange(Sender: TObject);
begin
  if FShowIndicator then InvalidateIndicator;
end;

procedure TCustomDBGridView.Insert(AppendMode: Boolean);
var
  AllowInsert: Boolean;
begin
  { � ������� �� �������� ������ }
  if (not Datalink.Active) or (DataLink.DataSet = nil) then Exit;
  { ��������� ������ }
  with Datalink.DataSet do
    if (State <> dsInsert) and CanModify and (not ReadOnly) and (not RowSelect) then
    begin
      { ���������� ���������� �� ������� }
      AllowInsert := FAllowInsertRecord;
      if Assigned(FOnDataInsertRecord) then FOnDataInsertRecord(Self, AllowInsert);
      { ��������� }
      if AllowInsert then
      begin
        if AppendMode then Append else Insert;
        Editing := True;
      end;
    end;
end;

function TCustomDBGridView.IsColumnsStored: Boolean;
begin
  Result := False;
end;

procedure TCustomDBGridView.SelectAll;
var
  OldCurrent: TBookmark;
begin
  { � ������� �� �������� ������ }
  if (not Datalink.Active) or (DataLink.DataSet = nil) then Exit;
  { ��������� ���� ��������� ������ � ������ �������������� ���������,
    ���� ����� ������ ������, �� ��� ���� ������������ Ctrl+A }
  if (not MultiSelect) or Editing then Exit;
  { �������� }
  with DataLink.DataSet, FSelectedRows do
  begin
    CheckBrowseMode;
    DisableControls;
    try
      Clear;
      OldCurrent := Bookmark;
      First;
      while not EOF do
      begin
        CurrentRowSelected := True;
        Next;
      end;
      Bookmark := OldCurrent;
      UpdateSelectionMark;
    finally
      EnableControls;
    end;
  end;
  InvalidateGrid;
end;

procedure TCustomDBGridView.SetCol(Value: Longint);
begin
  inherited Col := Value;
end;

procedure TCustomDBGridView.SetColumns(Value: TDBGridColumns);
begin
  Columns.Assign(Value);
end;

procedure TCustomDBGridView.SetDataSource(Value: TDataSource);
begin
  if DataLink.DataSource <> Value then
  begin
    if DataLink.DataSource <> nil then DataLink.DataSource.RemoveFreeNotification(Self);
    DataLink.DataSource := Value;
    if DataLink.DataSource <> nil then DataLink.DataSource.FreeNotification(Self);
    DataLayoutChanged;
  end;
end;

procedure TCustomDBGridView.SetDefaultLayout(Value: Boolean);
begin
  if FDefaultLayout <> Value then
  begin
    FDefaultLayout := Value;
    DataLayoutChanged;
    Invalidate;
  end;
end;

procedure TCustomDBGridView.SetFieldText(Field: TField; const Text: string);
begin
  if Assigned(FOnSetFieldText) then FOnSetFieldText(Self, Field, Text)
  else Field.Text := Text;
end;

procedure TCustomDBGridView.SetFixed(Value: TDBGridFixed);
begin
  Fixed.Assign(Value);
end;

procedure TCustomDBGridView.SetHeader(Value: TDBGridHeader);
begin
  Header.Assign(Value);
end;

procedure TCustomDBGridView.SetIndicatorImages(Value: TImageList);
begin
  if FIndicatorImages <> Value then
  begin
    if Assigned(FIndicatorImages) then FIndicatorImages.UnRegisterChanges(FIndicatorsLink);
    FIndicatorImages := Value;
    if Assigned(FIndicatorImages) then
    begin
      FIndicatorImages.RegisterChanges(FIndicatorsLink);
      FIndicatorImages.FreeNotification(Self);
    end;
    ChangeIndicator;
  end;
end;

procedure TCustomDBGridView.SetIndicatorWidth(Value: Integer);
begin
  if FIndicatorWidth <> Value then
  begin
    FIndicatorWidth := Value;
    ChangeIndicator;
  end;
end;

procedure TCustomDBGridView.SetMultiSelect(Value: Boolean);
begin
  if FMultiSelect <> Value then
  begin
    FMultiSelect := Value;
    if not Value then
    begin
      FSelectedRows.Clear;
      InvalidateGrid;
    end;
  end;
end;

procedure TCustomDBGridView.SetRows(Value: TDBGridRows);
begin
  Rows.Assign(Value);
end;

procedure TCustomDBGridView.SetSelectedField(Value: TField);
var
  I: Integer;
begin
  if Value <> nil then
    for I := 0 to Columns.Count - 1 do
      if Columns[I].Field = Value then
      begin
        Col := I;
        Break;
      end;
end;

procedure TCustomDBGridView.SetShowIndicator(Value: Boolean);
begin
  if FShowIndicator <> Value then
  begin
    FShowIndicator := Value;
    ChangeIndicator;
  end;
end;

procedure TCustomDBGridView.ShowCursor;
begin
  inherited;
  InvalidateIndicatorImage(Row);
end;

procedure TCustomDBGridView.ReadColumns(Reader: TReader);
begin
  Columns.Clear;
  Reader.ReadValue;
  Reader.ReadCollection(Columns);
end;

procedure TCustomDBGridView.WriteColumns(Writer: TWriter);
begin
  Writer.WriteCollection(Columns);
end;

procedure TCustomDBGridView.CMExit(var Message: TMessage);
begin
  if CancelOnExit then
  try
    CancelOrUpdateData;
  except
    AcquireFocus;
    raise;
  end;
  inherited;
end;

procedure TCustomDBGridView.WMContextMenu(var Message: TMessage);
begin
  { ����� ������� ������������ ���� ����������� ��������� ������ �
    ���������� ����� �������, � �.�. ���������� ����� ������� ��������
    ������ �� ������ ����������, �� ��� ����������� ���� �������� ��
    �����, ������������� �� ����� ��������� WM_CONTEXTMENU �� ����
    "����������" ��������� }
  Inc(FContextPopup);
  try
    inherited;
  finally
    Dec(FContextPopup);
  end;
end;

procedure TCustomDBGridView.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  if FSelectedRows.Count > 0 then InvalidateSelected;
end;

procedure TCustomDBGridView.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if FSelectedRows.Count > 0 then InvalidateSelected;
end;

function TCustomDBGridView.AcquireLockLayout: Boolean;
begin
  Result := (UpdateLock = 0) and (FLayoutLock = 0);
  if Result then LockLayout;
end;

procedure TCustomDBGridView.ChangeIndicator;
begin
  { ����������� ��������� ������� }
  UpdateHeader;
  UpdateScrollBars;
  UpdateVisOriginSize;
  UpdateCursorPos(False);
  UpdateEdit(Editing);
  { �������������� ������� }
  Invalidate;
end;

procedure TCustomDBGridView.ChangeScale(M, D: Integer);
begin
  inherited ChangeScale(M, D);
  { ����������� ������ ���������� }
  if M <> D then FIndicatorWidth := MulDiv(FIndicatorWidth, M, D);
end;

function TCustomDBGridView.CreateColumns: TGridColumns;
begin
  { TCustomDBGridView ����� ���� ����� ������� }
  Result := TDBGridColumns.Create(Self);
end;

function TCustomDBGridView.CreateDataLink: TDBGridDataLink;
begin
  Result := TDBGridDataLink.Create(Self);
end;

function TCustomDBGridView.CreateFixed: TCustomGridFixed;
begin
  { TCustomDBGridView ����� ���� ������������� ������� }
  Result := TDBGridFixed.Create(Self);
end;

function TCustomDBGridView.CreateHeader: TCustomGridHeader;
begin
  { TCustomDBGridView ����� ���� ��������� }
  Result := TDBGridHeader.Create(Self);
end;

function TCustomDBGridView.CreateRows: TCustomGridRows;
begin
  { TCustomDBGridView ����� ���� ������ ����� }
  Result := TDBGridRows.Create(Self);
end;

function TCustomDBGridView.CreateScrollBar(Kind: TScrollBarKind): TGridScrollBar;
begin
  if Kind = sbVertical then
    { TCustomDBGridView ����� ���� ������������ �������� }
    Result := TDBGridScrollBar.Create(Self, Kind)
  else
    Result := inherited CreateScrollBar(Kind);
end;

procedure TCustomDBGridView.DataEditError(E: Exception; var Action: TDBGridDataAction);
begin
  if Assigned(FOnDataEditError) then FOnDataEditError(Self, E, Action);
end;

procedure TCustomDBGridView.DataFieldUpdated(Field: TField);
begin
  if Assigned(FOnDataUpdateField) then FOnDataUpdateField(Self, Field);
end;

procedure TCustomDBGridView.DataLayoutChanged;
begin
  if AcquireLockLayout then UnLockLayout(False);
end;

procedure TCustomDBGridView.DataLinkActivate(Active: Boolean);
begin
  FSelectedRows.Clear;
  ResetClickPos;
  { ��� ��������� �������� Active ��������� ������ ���������� ��������
    ��������� �������, ������������ �������� � ���������� ������ ����� }
  DataLayoutChanged;
  UpdateScrollBars;
  UpdateScrollPos;
  UpdateCursorPos(True);
  UpdateEdit(Editing);
  { ��� ��������� ���������� ��������� ���� ������ ������������� �������,
    ����� ���� ����� �������� ������ (SQL ������) ���� �� �� ������� �
    ���������� �����, ��� � ������ ��������, �� ������� �� ������������
    ������������� � �� �� ������ ����� ������ }
  Invalidate;
end;

procedure TCustomDBGridView.DataRecordChanged(Field: TField);
var
  I: Integer;
  CField: TField;
begin
  if Field <> nil then
  begin
    { �������������� ������� ���� �� ��������� ��������� }
    for I := 0 to Columns.Count - 1 do
      if Columns[I].Field = Field then InvalidateColumn(I);
    { �������������� ������� ������, �.�. �� �������� �������� ����
      ����� �������� ������ ���� }
    InvalidateRow(CellFocused.Row);
    { ��������� ������ �����, ���� ���������� ������� ������������� ���� }
    CField := EditField;
    if (CField = Field) and (CField.Text <> FFieldText) then
    begin
      UpdateEditContents(False);
      if Edit <> nil then Edit.Deselect;
    end;
  end
  else
    { ���� ���������� - ��������� ��� }
    InvalidateGrid;
end;

procedure TCustomDBGridView.DataSetChanged;
begin
  ResetClickPos;
  UpdateRowCount;
  UpdateScrollBars;
  UpdateCursorPos(False);
  UpdateEditContents(False);
  ValidateRect(Handle, nil);
  Invalidate;
  if Assigned(FOnDataChange) then FOnDataChange(Self);
end;

procedure TCustomDBGridView.DataSetScrolled(Distance: Integer);
var
  R: TRect;
begin
  HideCursor;
  try
    if DataLink.ActiveRecord >= Rows.Count then UpdateRowCount;
    UpdateScrollBars;
    UpdateCursorPos(True);
    { ���� ���������� ������� ������������ ������, �� �������������� ������� }
    if Distance <> 0 then
    begin
      if Abs(Distance) <= VisSize.Row then
      begin
        { �������� ����� ���� �� ��������� ����� }
        R := GetRowsRect(0, VisSize.Row - 1);
        ScrollWindowEx(Handle, 0, - Distance * Rows.Height, @R, @R, 0, nil, SW_INVALIDATE);
      end
      else
        { �������� ������, ��� ���������� ������� ����� }
        InvalidateGrid;
    end;
  finally
    ShowCursor;
  end;
end;

procedure TCustomDBGridView.DataUpdateError(E: Exception; var Action: TDBGridDataAction);
begin
  if Assigned(FOnDataUpdateError) then FOnDataUpdateError(Self, E, Action);
end;

procedure TCustomDBGridView.DefineProperties(Filer: TFiler);
var
  HasColumns: Boolean;
  AGrid: TCustomDBGridView;
begin
  { ������� �� ���� ����������, ���� ��� ������� ������������� ���
    ����������� }
  HasColumns := not DefaultLayout;
  if HasColumns and (Filer.Ancestor <> nil) then
  begin
    AGrid := TCustomDBGridView(Filer.Ancestor);
    if not AGrid.DefaultLayout then
      HasColumns := not CollectionsEqual(Columns, AGrid.Columns, nil, nil);
  end;
  { ���������� ������� }
  Filer.DefineProperty('Columns', ReadColumns, WriteColumns, HasColumns);
end;

procedure TCustomDBGridView.Delete;
const
  SDeleteMsg: array[Boolean] of string = (SDeleteRecordQuestion, SDeleteMultipleRecordsQuestion);
const
  Flags = MB_ICONQUESTION or MB_YESNO;
var
  AllowDelete: Boolean;
  Msg: string;
  I: Integer;
begin
  { � ������� �� �������� ������ }
  if (not Datalink.Active) or (DataLink.DataSet = nil) then Exit;
  { ��������� ������ }
  with Datalink.DataSet do
    if (State <> dsInsert) and (not IsEmpty) and CanModify and (not ReadOnly) and
      (not MultiSelect or (FSelectedRows.Count > 0)) then
    begin
      AllowDelete := FAllowDeleteRecord;
      { ���� ���� ���������� ������� �� �������� ������, �� ����������
        ���������� �� �������� � ���� ����� ���������� ������ ���� }
      if not Assigned(FOnDataDeleteRecord) then
      begin
        Msg := SDeleteMsg[FSelectedRows.Count > 1];
        with Application do
          AllowDelete := AllowDelete and (MessageBox(PChar(Msg), PChar(Title), Flags) = ID_YES);
      end
      else
        FOnDataDeleteRecord(Self, AllowDelete);
      { ������� }
      if AllowDelete then
      begin
        DisableControls;
        try
          if not MultiSelect then
            Delete
          else
            for I := FSelectedRows.Count - 1 downto 0 do
            begin
              Bookmark := FSelectedRows.Bookmarks[I];
              Delete;
              FSelectedRows.Delete(I);
            end;
        finally
          EnableControls;
        end;
      end;
    end;
end;

function TCustomDBGridView.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  KeepSelected: Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if Result and (gkMouseWheel in CursorKeys) then
  begin
    if not (ssShift in Shift) then
    begin
      MoveBy(1, Shift);
      KeepSelected := FSelectedRows.CurrentRowSelected;
      SetCursor(CellFocused, KeepSelected, True);
    end
    else if not RowSelect then
    begin
      MoveBy(0, Shift - [ssShift]);
      KeepSelected := FSelectedRows.CurrentRowSelected;
      SetCursor(CellFocused, KeepSelected, True)
    end;
  end;
end;

function TCustomDBGridView.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  KeepSelected: Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if Result and (gkMouseWheel in CursorKeys) then
  begin
    if not (ssShift in Shift) then
    begin
      MoveBy(-1, Shift);
      KeepSelected := FSelectedRows.CurrentRowSelected;
      SetCursor(CellFocused, KeepSelected, True)
    end
    else if not RowSelect then
    begin
      MoveBy(0, Shift - [ssShift]);
      KeepSelected := FSelectedRows.CurrentRowSelected;
      SetCursor(CellFocused, KeepSelected, True)
    end;
  end;
end;

function TCustomDBGridView.EditCanAcceptKey(Cell: TGridCell; Key: Char): Boolean;
begin
  Result := False;
  { ��������� ������� � �������� }
  if IsCellValid(Cell) and (Cell.Col >= Fixed.Count) and DataLink.Active then
  begin
    { � ����� �� ���� ��������� ������ ������ }
    with Columns[Cell.Col] do
      Result := (Field <> nil) and Field.IsValidChar(Key);
    { ���������� ������������ (�� ����� ��������� ���� ��������������
      ��������) }
    if Assigned(OnEditAcceptKey) then OnEditAcceptKey(Self, Cell, Key, Result);
  end;
end;

function TCustomDBGridView.EditCanModify(Cell: TGridCell): Boolean;
var
  Action: TDBGridDataAction;
begin
  { ��������� ����������� ��������� ������, ��������� � ���� }
  Result := inherited EditCanModify(Cell) and DataLink.Active and
    (not Datalink.ReadOnly) and (not IsReadOnlyField(EditField)) and
    (EditField <> nil) and (EditField.CanModify);
  { ���� ������������� �����, �� ��������� �������� � ����� �������������� }
  if Result then
  try
    if not Datalink.Editing then Result := DataLink.Edit;
    if Result then Datalink.Modified;
  except
    on E: Exception do
    begin
      { ������� (����� EAbort) }
      if not (E is EAbort) then
      begin
        Action := gdaFail;
        DataEditError(E, Action);
      end
      else
        Action := gdaAbort;
      { ��������� ���������� }
      if Action = gdaFail then raise;
      if Action = gdaAbort then SysUtils.Abort;
    end;
  end;
end;

function TCustomDBGridView.EditCanShow(Cell: TGridCell): Boolean;
begin
  Result := DataLink.Active and inherited EditCanShow(Cell);
end;

function TCustomDBGridView.FindText(const FindText: string; Options: TFindOptions): Boolean;

  function CompareCell(Col, Row: Integer): Boolean;
  var
    C: TGridCell;
    T: string;
  begin
    Result := False;
    { ���������� ��������� � ������� ������� }
    if Columns[Col].Width > 0 then
    begin
      C := GridCell(Col, Row);
      T := GetCellText(C);
      if CompareStrings(FindText, T, frWholeWord in Options, frMatchCase in Options) then
      begin
        SetCursor(C, True, True);
        Result := True;
      end;
    end;
  end;

var
  Bookmark: TBookmark;
  I: Integer;
begin
  { ������ ����� ������ � �������� ��������� }
  if DataLink.Active and (DataLink.DataSet <> nil) then
  begin
    DataLink.DataSet.DisableControls;
    try
      Result := True;
      { ���� ������ �� ������, �� ����� ������� DataSet �� ������� ������ }
      Bookmark := DataLink.DataSet.Bookmark;
      { ���� ����� }
      if frDown in Options then
      begin
        { ����� ����: ���������� ������ ���� ����� �������, ������� ��
          ��������� ������ ������������ ������� }
        I := CellFocused.Col + 1;
        while not DataLink.EOF do
        begin
          while I <= Columns.Count - 1 do
          begin
            if CompareCell(I, DataLink.ActiveRecord) then Exit;
            Inc(I);
          end;
          DataLink.MoveBy(1);
          I := 0;
        end;
      end
      else
      begin
        { ����� �����: ���������� ������ ����� ������ ������, ������� �
          ���������� ������ ������������ ������� }
        I := CellFocused.Col - 1;
        { ������ ������: ��� ������ ����� ������������� ������ �����
          ���������� (��. ����������� � TCustomGridView.FindText) }
        while (I >= 0) and (Columns[I].Width = 0) do Dec(I);
        if (I < Fixed.Count) and (not DataLink.BOF) then
        begin
          DataLink.MoveBy(-1);
          I := Columns.Count - 1;
        end;
        while not DataLink.BOF do
        begin
          while I >= 0 do
          begin
            if CompareCell(I, DataLink.ActiveRecord) then Exit;
            Dec(I);
          end;
          DataLink.MoveBy(-1);
          I := Columns.Count - 1;
        end;
      end;
      { ����� ������� - ���������� ������� ������ }
      DataLink.DataSet.Bookmark := Bookmark;
    finally
      DataLink.DataSet.EnableControls;
    end;
    { ������ �� ����� }
    DoTextNotFound(FindText);
  end;
  Result := False;
end;

procedure TCustomDBGridView.GetCellColors(Cell: TGridCell; Canvas: TCanvas);
var
  OldActive: Integer;
begin
  if DataLink.Active and IsCellValidEx(Cell, True, False) then
  begin
    OldActive := DataLink.ActiveRecord;
    try
      { ������ �������� �� ������ ������ � �������� �� ���� }
      DataLink.ActiveRecord := Cell.Row;
      inherited;
    finally
      DataLink.ActiveRecord := OldActive;
    end;
  end
  else
    inherited;
end;

function TCustomDBGridView.GetCellText(Cell: TGridCell): string;
var
  OldActive: Integer;
  Field: TField;
begin
  { ����� ����� �������� ������ ��� ������� ������ }
  if DataLink.Active and IsCellValidEx(Cell, True, False) then
  begin
    OldActive := DataLink.ActiveRecord;
    try
      { ������ �������� �� ������ ������ � �������� ����� ���� ������� }
      DataLink.ActiveRecord := Cell.Row;
      Field := Columns[Cell.Col].Field;
      if (Field <> nil) and (Field.DataSet <> nil) then Result := Field.DisplayText;
      { ���������� ������������ }
      if Assigned(OnGetCellText) then OnGetCellText(Self, Cell, Result);
    finally
      DataLink.ActiveRecord := OldActive;
    end;
  end
  else
    Result := inherited GetCellText(Cell);
end;

function TCustomDBGridView.GetColumnClass: TGridColumnClass;
begin
  Result := TDBGridColumn;
end;

function TCustomDBGridView.GetEditClass(Cell: TGridCell): TGridEditClass;
begin
  Result := TDBGridEdit;
end;

function TCustomDBGridView.GetEditText(Cell: TGridCell): string;
begin
  Result := inherited GetEditText(Cell);
  { ���������� �������� (����, � �� ��, ��� ������������ ��������� �
    ������ � ������� OnGetCellText ��� OnGetEditText }
  if EditField <> nil then FFieldText := EditField.Text else FFieldText := '';
end;

procedure TCustomDBGridView.HideCursor;
begin
  inherited;
  InvalidateIndicatorImage(Row);
end;

procedure TCustomDBGridView.InvalidateGrid;
begin
  inherited;
  InvalidateIndicator;
end;

procedure TCustomDBGridView.InvalidateIndicator;
begin
  InvalidateRect(GetIndicatorHeaderRect);
  InvalidateRect(GetIndicatorFixedRect);
end;

procedure TCustomDBGridView.InvalidateIndicatorImage(DataRow: Integer);
begin
  InvalidateRect(GetIndicatorImageRect(DataRow));
end;

procedure TCustomDBGridView.InvalidateRow(Row: Integer);
begin
  inherited;
  InvalidateIndicatorImage(Row);
end;

procedure TCustomDBGridView.InvalidateSelected;
begin
  InvalidateGrid;
end;

procedure TCustomDBGridView.KeyDown(var Key: Word; Shift: TShiftState);
var
  KeyScroll, CtrlSelected, KeepSelected: Boolean;
begin
  KeyScroll := Key in [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_HOME, VK_END,
    VK_TAB, VK_RETURN, VK_ESCAPE, VK_INSERT, VK_DELETE];
  { ��������� ����������� ������� � ����������� TCustomGridView.KeyDown �
    � ������� OnKeyDown (���� ����) }
  if KeyScroll then LockScroll;
  try
    inherited;
    { � ������� �� �������� ������ }
    if (not DataLink.Active) or (DataLink.DataSet = nil) then Exit;
    { �.�. ��� ��������� ������� ������ � ���������� ������ MoveBy �����
      ���������� ���������� ���������� ������, �� ��� ������� �������� � ��
      ���� ������� ������� ���������, ����� ����� ���������� UnLockScroll
      ����� ����������� ������� ���������� UpdateRecord � ������ ������
      ��������� �� ������ }
    try
      { ����������� �� ������� ��������� }
      if gkArrows in CursorKeys then
      begin
        CtrlSelected := MultiSelect and (Shift = [ssCtrl]);
        case Key of
          VK_LEFT:
            begin
              MoveBy(0, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(CellFocused, KeepSelected, True);
            end;
          VK_RIGHT:
            begin
              MoveBy(0, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(CellFocused, KeepSelected, True);
            end;
          VK_UP:
            { ������ ������� ����� ������ � ������� �� ���������� ������ }
            begin
              MoveBy(-1, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(CellFocused, KeepSelected, True);
            end;
          VK_DOWN:
            { ������� �� ��������� ������ ��� ������� ����� ������, ����
              ������ ��������� � ����� ������� }
            begin
              MoveBy(1, Shift);
              { �.�. ��� ������� ����� ������ ���������� ��������� ���������
                ������� �� ������� �� DataLink, ���������� �� ����������
                �������� ������� LockScroll, �� ������� ��� ��� �������
                ��������� �������, ����� ����� ������ ���������� �� �������
                ���, ���� ��� �������� DataLink }
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(CellFocused, KeepSelected, True);
            end;
          VK_PRIOR:
            { ������� � ����� ���� ��� �� �������� ����� }
            begin
              MoveBy(-VisSize.Row, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(FScrollCell, KeepSelected, True);
            end;
          VK_NEXT:
            { ������� � ����� ��� ��� �� �������� ���� }
            begin
              MoveBy(VisSize.Row, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(FScrollCell, KeepSelected, True);
            end;
          VK_HOME:
            { � ������ ������� }
            if ssCtrl in Shift then
            begin
              MoveBy(DBGRID_BOF, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(FScrollCell, KeepSelected, True);
            end;
          VK_END:
            { � ����� ������� }
            if ssCtrl in Shift then
            begin
              MoveBy(DBGRID_EOF, Shift);
              KeepSelected := (not CtrlSelected) or FSelectedRows.CurrentRowSelected;
              SetCursor(FScrollCell, KeepSelected, True);
            end;
          VK_SPACE:
            if ssCtrl in Shift then
            begin
              MoveBy(0, Shift + [ssMiddle]);
              KeepSelected := FSelectedRows.CurrentRowSelected;
              SetCursor(CellFocused, KeepSelected, True);
            end;
        end;
      end;
      { ����������� �� ������� ���������� }
      if (gkTabs in CursorKeys) and (Key = VK_TAB) and (not RowSelect) then
      begin
        { TAB �� ��������� ������� � ������ - ������ �� ��������� ������ }
        if (CellFocused.Col = Columns.Count - 1) and (not (ssShift in Shift)) then
        begin
          MoveBy(1, []);
          SetCursor(GetCursorCell(CellFocused, goHome), True, True);
        end;
        { TAB �� ������ ������� � ������ - ������ �� ���������� ������ }
        if (CellFocused.Col = Fixed.Count) and (ssShift in Shift) then
        begin
          MoveBy(-1, []);
          SetCursor(GetCursorCell(CellFocused, goEnd), True, True);
        end;
      end;
      { ��������� ������� }
      case Key of
        VK_ESCAPE:
          { ������� ������� ESCAPE �������� � ������ ��������� �������
            ������, ���� ���� �� ����� ������ ������������� }
          begin
            CancelEdit;
            { � ������ ������ ������� ������ � ����� ������� �������
              ��������� ������� �������� �� ��������� ������� � �������
              ������� ������������� ���������� ���������� ������ �� ������
              ���������� ��������� ������. ����� ��� ���� �� ������� �������
              ������� ��������� �� ���� }
            SetCursor(CellFocused, True, True);
          end;
        VK_INSERT:
          { ������� INSERT ��� ���������� ������ �������������� �������� �
            ������� ����� ������ }
          if (Shift = []) and (not Editing) then Insert(False);
        VK_DELETE:
          { ������� INSERT ��� ���������� ������ �������������� �������� �
            �������� ������� ������ }
          if (Shift = []) and (not Editing) then
          begin
            Delete;
            SetCursor(CellFocused, True, True);
          end;
      end;
    except
      SetCursor(CellFocused, True, True);
      raise;
    end;
  finally
    if KeyScroll then UnLockScroll(False);
  end;
end;

procedure TCustomDBGridView.KeyPress(var Key: Char);
var
  ReturnScroll: Boolean;
begin
  { ���� ������ RETURN � ���� ���������� �� ��������� ������, �� ��
    ����� ������� ������ � ����������� �����������, � ������� ��� ����,
    �.�. ����� ������ ������ ���� ��������� ������� � ����� �������
    ����� ������ }
  ReturnScroll := (Key = #13) and (gkReturn in CursorKeys) and Editing;
  { ��������� ����������� ������� � ����������� ����������� }
  if ReturnScroll then LockScroll;
  try
    inherited;
    { Return �� ��������� ������� � ������ - ������ �� ��������� ������ }
    if ReturnScroll and (CellFocused.Col = Columns.Count - 1) then
    begin
      MoveBy(1, []);
      SetCursor(GetCursorCell(CellFocused, goHome), True, True);
    end;
  finally
    if ReturnScroll then UnLockScroll(False);
  end;
end;

procedure TCustomDBGridView.Loaded;
begin
  inherited;
  DataLayoutChanged;
end;

procedure TCustomDBGridView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { ������������� ����� �� ���� ��� ���� ������ ����� }
  if not AcquireFocus then
  begin
    MouseCapture := False;
    Exit;
  end;
  { �������� ������� ������ }
  if not (ssDouble in Shift) then
  begin
    if ssCtrl in Shift then Shift := Shift + [ssMiddle]; // <- ������ Space
    { �������� �� ���������� ������ - ��������� ���������� ���������, �����
      ���������� ����� ������ �������������� ���������� }
    if IsCellHighlighted(GetCellAt(X, Y)) then
    begin
      FSelectPending := True;
      FSelectPos := Point(X, Y);
      FSelectShift := Shift;
    end
    else
      MoveByXY(X, Y, Shift);
  end;
  { ����������� ��������� � �������� ���������� ������ � MouseDown }
  inherited;
end;

procedure TCustomDBGridView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  { �������� ����� - �������� ���������� ��������� }
  if FSelectPending then
  begin
    FSelectPending := False;
  end;
  { ���� ���� ��������� ������ �������, �� ��������� ������ ���������� }
  if (gkMouseMove in CursorKeys) and (not ColResizing) then
    MoveByXY(X, Y, Shift);
  inherited;
end;

procedure TCustomDBGridView.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  { ����������� ���������� ��������� }
  if FSelectPending then
  begin
    FSelectPending := False;
    MoveByXY(FSelectPos.X, FSelectPos.Y, FSelectShift);
  end;
  inherited;
end;

procedure TCustomDBGridView.MoveBy(Distance: Integer; Shift: TShiftState);
var
  RowCount, Direction, Direction2: Integer;
  OldCurrent: TBookmark;
  I, Index1, Index2: Integer;
begin
  if (not Datalink.Active) or (DataLink.DataSet = nil) then Exit;
  { �������� ������� ������ ��� ������� Down �� ������ ������ � ��� �������
    Up �� ��������� ������ �������, � ��������� ������� ������� �����
    �������� ������������� ��� ������� ������� }
  with DataLink.DataSet do
    if (State = dsInsert) and (not Modified) and (not Datalink.FModified) then
      if Distance > 0 then
      begin
        if not EOF then CancelOrUpdateData;
        Exit;
      end
      else if (Distance < 0) and EOF then
      begin
        CancelOrUpdateData;
        Exit;
      end;
  { ���������� �������� ������ � ��������� }
  if not MultiSelect then
  begin
    { ��� ����������� MultiSelect ������ ������� ������, �� ���������
      �������� ���� ������� (��. CellSelected) }
    DataLink.MoveBy(Distance);
  end
  else if ssRight in Shift then
  begin
    { ������� ������ ������� (�������� ������ ��� ���������� RightClickSelect)
      ��� ���������� ���������� ��������� ���������� �� ��������� Ctrl � Shift,
      ������� �� ���������� ������ ������ �� ������  }
    InvalidateRow(CellFocused.Row);
    DataLink.MoveBy(Distance);
    if not FSelectedRows.CurrentRowSelected then
    begin
      FSelectedRows.Clear;
      FSelectedRows.CurrentRowSelected := True;
      InvalidateRow(CellFocused.Row);
    end;
  end
  else if Shift * [ssShift, ssCtrl] = [] then
  begin
    { �������� ������� ��� Shift � Ctrl ���������� ������ ��������� �
      �������� ����� ������, ������ ��������� ����������� �� ����� ������ }
    InvalidateRow(CellFocused.Row);
    FSelectedRows.Clear;
    DataLink.MoveBy(Distance);
    FSelectedRows.CurrentRowSelected := True;
    FSelectedRows.UpdateSelectionMark;
    InvalidateRow(CellFocused.Row);
  end
  else if ssShift in Shift then
  begin
    Direction := Sign(Distance);
    RowCount := Abs(Distance);
    with DataLink.DataSet, FSelectedRows do
    begin
      DisableControls;
      try
        { ������ � ����������� ��������� }
        if not Selecting then
        begin
          { ���� ��������� ��� �� ����, �� ��������� ������� ������ �������� }
          UpdateSelectionMark;
        end
        else if (Distance <> 0) and not (ssCtrl in Shift) then
        begin
          { �� �������� � Expolrer ������� ������ ��������� �������� ���������
            ��������� ����� ����� ��� ������� Ctrl, �� ���� Ctrl ���, �� ���
            ���������� ������ ����� ������� ����� �������� }
          Find(SelectionMark, Index1);
          Find(CurrentRow, Index2);
          for I := Count - 1 downto Max(Index1, Index2) + 1 do Delete(I);
          for I := Min(Index1, Index2) - 1 downto 0 do Delete(I);
        end;
        { �������� ������� � ������ ������� ������� ��������� �����, ��
          �� ������ ������� }
        Direction2 := Compare(SelectionMark, CurrentRow);
        if Direction2 = Direction then
          while (Direction2 <> 0) and (RowCount > 0) do
          begin
            CurrentRowSelected := ssCtrl in Shift; // <- Ctrl ��������� �� ����������
            DataLink.MoveBy(Direction);
            Dec(RowCount);
            if BOF or EOF then Break;
            Direction2 := Compare(SelectionMark, CurrentRow);
          end;
        { ���� ������ ��������� � ������� �������, �� �� ���� �� �����, ���
          ���� ������ ����� ��������� � �������� �� ������� �������, ��
          ����� ��� � �������� �������� ������ - ��� ������ �������� }
        Direction2 := Compare(SelectionMark, CurrentRow);
        if Direction2 <> 0 then
        begin
          OldCurrent := Bookmark;
          while Direction2 <> 0 do
          begin
            DataLink.MoveBy(Direction2);
            CurrentRowSelected := True;
            if BOF or EOF then Break;
            Direction2 := Compare(SelectionMark, CurrentRow);
          end;
          Bookmark := OldCurrent;
        end;
        { ���������� �������� ������ ���� � ������� �� ������� � ������
          �������� ������ }
        while RowCount > 0 do
        begin
          CurrentRowSelected := True;
          DataLink.MoveBy(Direction);
          Dec(RowCount);
          if BOF or EOF then Break;
        end;
        { ������ ����� �������� ������ ������� }
        CurrentRowSelected := True;
      finally
        EnableControls;
      end;
    end
  end
  else // ssCtrl in Shift
  begin
    { �������� ������� � ������� Ctrl �� ������ ������� ��������� ����� }
    InvalidateRow(CellFocused.Row);
    DataLink.MoveBy(Distance);
    { ����������: Ctrl+Space ����������� ��������� ����� ������ � ���������
      �� ��� ������ ��������� }
    if ssMiddle in Shift then
    begin
      FSelectedRows.CurrentRowSelected := not FSelectedRows.CurrentRowSelected;
      FSelectedRows.UpdateSelectionMark;
    end;
    InvalidateRow(CellFocused.Row);
  end;
  { ���� � ������ ������ �������� ������� �����, �� ��������� � ������
    ������� ����� ������, ��� ������� ������� ���� �� ��������� ������
    ��������� ����� ������ � ����� ������� }
  with DataLink.DataSet do
    if (State <> dsInsert) then
    begin
      //if BOF and (Distance = -1) then Self.Insert(False);
      if EOF and (Distance = 1) then Self.Insert(True);
    end;
end;

procedure TCustomDBGridView.MoveByXY(X, Y: Integer; Shift: TShiftState);
var
  C: TGridCell;
  KeepSelected: Boolean;

  function IsLeftButtonPressed: Boolean;
  begin
    Result := (ssLeft in Shift) or ((ssRight in Shift) and RightClickSelect);
  end;

begin
  { ���� ����� �������� ������, �� ��������� ������� ����� ������ �� ������ }
  if (gkMouse in CursorKeys) and IsLeftButtonPressed then
  begin
    { �������, ���� ������ }
    if PtInRect(GetIndicatorFixedRect, Point(X, Y)) then
    begin
      { ������ �� ��������� }
      C.Col := CellFocused.Col;
      C.Row := GetRowAt(X, Y);
    end
    else if PtInRect(GetGridRect, Point(X, Y)) then
      { ������ �� ������ }
      C := GetCellAt(X, Y)
    else
      Exit;
    { ���� � ������� ��� ����� ��� ������ � ��������� �����, �� ������
      ��������� ��������� ������ (-1,-1) }
    if C.Row = -1 then
    begin
      if Shift * [ssShift, ssCtrl] = [] then FSelectedRows.Clear;
      Exit;
    end;
    { ������ ������ � ������ }
    LockScroll;
    try
      MoveBy(C.Row - CellFocused.Row, Shift);
      KeepSelected := (not (ssCtrl in Shift)) or FSelectedRows.CurrentRowSelected;
      SetCursor(C, KeepSelected, True);
    finally
      UnLockScroll(False);
    end;
  end;
end;

procedure TCustomDBGridView.MoveTo(RecNo: Integer; Shift: TShiftState);
begin
  if DataLink.Active and (DataLink.DataSet <> nil) then
  begin
    DataLink.DataSet.RecNo := RecNo;
    MoveBy(0, Shift);
  end;
end;

procedure TCustomDBGridView.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: Integer;
  NeedRefresh: Boolean;
begin
  inherited;
  if Operation = opRemove then
    if AComponent is TField then
    begin
      NeedRefresh := False;
      LockUpdate;
      try
        if Columns <> nil then
          for I := Columns.Count - 1 downto 0 do
            if Columns[I].FField = AComponent then
            begin
              Columns[I].FField := nil;
              NeedRefresh := True;
            end;
      finally
        UnlockUpdate(NeedRefresh);
      end;
    end
    else if AComponent = DataSource then
      DataSource := nil
    else if AComponent = FIndicatorImages then
      IndicatorImages := nil;
end;

procedure TCustomDBGridView.Paint;
var
  R: TRect;
begin
  if ShowIndicator then
  begin
    PaintIndicatorHeader;
    PaintIndicatorFixed;
    if GridLines then PaintIndicatorGridLines;
    { �������� ������������� ���������� }
    R := GetIndicatorHeaderRect;
    ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    R := GetIndicatorFixedRect;
    ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
  end;
  inherited;
end;

procedure TCustomDBGridView.PaintCell(Cell: TGridCell; Rect: TRect);
var
  OldActive: Integer;
begin
  OldActive := DataLink.ActiveRecord;
  try
    { ����� ���������� ������ ������������� ��������� ������� ������ ��
      ������ ������, ����� �������� Columns[Cell.Row].Field ��������������
      ������ ���� ������ }
    DataLink.ActiveRecord := Cell.Row;
    inherited;
  finally
    DataLink.ActiveRecord := OldActive;
  end;
end;

procedure TCustomDBGridView.PaintIndicatorFixed;
var
  J: Integer;
  R: TRect;
begin
  { ������� ����� }
  R := GetIndicatorFixedRect;
  R.Bottom := GetRowRect(VisOrigin.Row).Top;
  { ���������� ������ }
  for J := 0 to VisSize.Row - 1 do
  begin
    R.Top := R.Bottom;
    R.Bottom := R.Bottom + Rows.Height;
    { ������ ������������ ���������� � �� �������� }
    if RectVisible(Canvas.Handle, R) then
    begin
      Canvas.Brush.Color := Fixed.Color;
      Canvas.FillRect(R);
      PaintIndicatorImage(R, J);
    end;
  end;
  { ������ ���� ����� }
  R.Top := R.Bottom;
  R.Bottom := GetIndicatorFixedRect.Bottom + 2;
  if not (gsListViewLike in GridStyle) then
    Canvas.Brush.Color := Color
  else
    Canvas.Brush.Color := Fixed.Color;
  Canvas.FillRect(R);
  { ������� ������ }
  if Fixed.Flat or StyleServices.Enabled then
  begin
    R := GetIndicatorFixedRect;
    { ���� ������������� �� �����, �� ������� ������ �� ��������� ������ }
    if not (IsFixedVisible or (gsListViewLike in GridStyle) or
      (gsFullVertLine in GridStyle)) then
    begin
      if VisSize.Row = 0 then Exit;
      R.Bottom := GetRowRect(VisOrigin.Row + VisSize.Row).Top;
    end;
    { ���� ����� ������������� � ������� ��������� - ������ �������
      �� ����� �����  }
    if Fixed.GridColor or StyleServices.Enabled then
    begin
      if not (gsDotLines in GridStyle) then
      begin
        Canvas.Pen.Color := GetFixedDividerColor;
        Canvas.Pen.Width := GridLineWidth;
        Canvas.MoveTo(R.Right - 1, R.Bottom - 1);
        Canvas.LineTo(R.Right - 1, R.Top - 1);
      end
      else
      begin
        R.Left := R.Right - 1;
        PaintDotGridLines(@R, 2);
      end;
    end
    else
      { ����� ������ ������� ������� }
      with Canvas do
      begin
        Pen.Color := clBtnShadow;
        Pen.Width := 1;
        MoveTo(R.Right - 2, R.Top - 1);
        LineTo(R.Right - 2, R.Bottom - 1);
        Pen.Color := clBtnHighlight;
        MoveTo(R.Right - 1, R.Bottom - 1);
        LineTo(R.Right - 1, R.Top - 1);
      end;
  end;
end;

procedure TCustomDBGridView.PaintIndicatorGridLines;
var
  Points: array of TPoint;
  PointCount: Integer;
  StrokeList: array of DWORD;
  StrokeCount: Integer;
  I, L, R, Y, C: Integer;
  Rect: TRect;

  procedure ShiftGridPoints(DX, DY: Integer);
  var
    I: Integer;
  begin
    for I := 0 to PointCount - 1 do
      Points[I].Y := Points[I].Y + DY;
  end;

  procedure Paint3DCells(Rect: TRect);
  var
    R: TRect;
  begin
    R := Rect;
    R.Bottom := R.Top;
    { ������ }
    while R.Bottom < Rect.Bottom do
    begin
      R.Top := R.Bottom;
      R.Bottom := R.Bottom + Rows.Height;
      if RectVisible(Canvas.Handle, R) then Paint3DFrame(R, BF_RECT);
    end;
  end;

  procedure PaintHorz3DLines(Rect: TRect);
  var
    R: TRect;
  begin
    R := Rect;
    R.Bottom := R.Top;
    { ������ }
    repeat
      R.Top := R.Bottom;
      R.Bottom := R.Bottom + Rows.Height;
      if RectVisible(Canvas.Handle, R) then Paint3DFrame(R, BF_RECT);
    until R.Bottom >= Rect.Bottom;
  end;

  procedure PaintBottom3DMargin(Rect: TRect);
  begin
    if RectVisible(Canvas.Handle, Rect) then
      Paint3DFrame(Rect, BF_LEFT or BF_TOP or BF_RIGHT);
  end;

begin
  { ������� ����� �������� ��� ���������� ����� ��� ���� ���� �������������
    ������ �� ������� }
  if StyleServices.Enabled or Fixed.Flat then
  begin
    { ���������� ������� �������������� ����� ����� ������������ �����������
      ������� ����� }
    StrokeCount := 0;
    if gsHorzLine in GridStyle then
    begin
      if gsListViewLike in GridStyle then StrokeCount := GetGridHeight div Rows.Height
      else StrokeCount := VisSize.Row;
    end;
    if StrokeCount > 0 then
    begin
      { �������� �� ��� ����� �� ������ ����� }
      SetLength(Points, StrokeCount * 2);
      SetLength(StrokeList, StrokeCount);
      for I := 0 to StrokeCount - 1 do StrokeList[I] := 2;
      { ����� �������������� ����� }
      Rect := GetIndicatorFixedRect;
      PointCount := 0;
      if gsHorzLine in GridStyle then
      begin
        L := Rect.Left;
        R := Rect.Right;
        Y := GetRowRect(VisOrigin.Row).Top;
        if gsListViewLike in GridStyle then C := GetGridHeight div Rows.Height
        else C := VisSize.Row;
        for I := 0 to C - 1 do
        begin
          Inc(Y, Rows.Height);
          Points[PointCount].X := L;
          Points[PointCount].Y := Y - 1;
          Inc(PointCount);
          Points[PointCount].X := R - 1;
          Points[PointCount].Y := Y - 1;
          Inc(PointCount);
        end;
      end;
      { ���� ���� ������������� �� ���������� �� ����� �������, �� � �����
        � ��� ����������, ��� ���������� ����� ������ ������ ��������� �����,
        ��� ����������� ����� �� ����� ���� ������ ������� ������� }
      if Fixed.GridColor or StyleServices.Enabled then
      begin
        { �������� ����� (��� ��������� ��� ������ ������� �����) }
        //ShiftGridPoints(1, 1);
        { ������ ��������� ������� }
        if not (gsDotLines in GridStyle) then
        begin
          Canvas.Pen.Color := GetFixedGridColor;
          Canvas.Pen.Width := GridLineWidth;
          PolyPolyLine(Canvas.Handle, Pointer(Points)^, Pointer(StrokeList)^, PointCount shr 1);
        end
        else
          PaintDotGridLines(Pointer(Points), PointCount);
      end
      else
      begin
        { ������ ����� }
        Canvas.Pen.Color := clBtnShadow;
        Canvas.Pen.Width := 1;
        PolyPolyLine(Canvas.Handle, Pointer(Points)^, Pointer(StrokeList)^, PointCount shr 1);
        { �������� ����� }
        ShiftGridPoints(1, 1);
        { ������� ����� }
        Canvas.Pen.Color := clBtnHighlight;
        PolyPolyLine(Canvas.Handle, Pointer(Points)^, Pointer(StrokeList)^, PointCount shr 1);
      end;
    end;
  end
  { ���� �� �������� 3D ������ }
  else if gsHorzLine in GridStyle then
  begin
    Rect := GetIndicatorFixedRect;
    if not (gsListViewLike in GridStyle) then Rect.Bottom := GetRowRect(VisOrigin.Row + VisSize.Row).Top;
    Paint3DCells(Rect);
  end
  else
  { ������ 3D ����� ������ ���������� }
  begin
    Rect := GetIndicatorFixedRect;
    if not IsFixedVisible then
    begin
      Rect.Bottom := GetRowRect(VisOrigin.Row + VisSize.Row).Top;
      Paint3DFrame(Rect, BF_RECT);
    end
    else
      PaintBottom3DMargin(Rect);
  end;
end;

procedure TCustomDBGridView.PaintIndicatorHeader;
const
  PaintState: array[Boolean] of TGridPaintStates = ([], [psFlat]);
begin
  PaintHeaderBackground(GetIndicatorHeaderRect, Header.Color, PaintState[Header.Flat]);
end;

procedure TCustomDBGridView.PaintIndicatorImage(Rect: TRect; DataRow: Integer);
var
  I, X, Y, W, H: Integer;
  IL: TImageList;
begin
  I := GetIndicatorImage(DataRow);
  if I = -1 then Exit;
  { ������������ ����� �������������� �������� ���������� }
  IL := FIndicatorImages;
  if IL = nil then IL := FIndicatorsDef;
  { ������ �������� }
  W := IL.Width;
  H := IL.Height;
  { ��������� �������� }
  X := Rect.Right - Rect.Left - W;
  X := Rect.Left + X div 2 - Ord(Fixed.Flat);
  Y := Rect.Bottom - Rect.Top - H;
  Y := Rect.Top + Y div 2 - Ord(Fixed.Flat);
  { ������ }
  IL.BkColor := Canvas.Brush.Color;
  IL.Draw(Canvas, X, Y, I, True);
end;

procedure TCustomDBGridView.ChangeEditText(const S: string);
begin
  { ��������� ����������� ��������� ������ � ������ }
  if Editing and EditCanModify(EditCell) then
  begin
    { ��������� ����� � ������, ������� ���� ��������� ������ }
    Edit.Text := S;
    DataLink.Modified;
  end;
end;

function TCustomDBGridView.IsCellReadOnly(Cell: TGridCell): Boolean;
begin
  { ������ ���������� ������ �������������� ��� lookup ��� �� ���������
    ����� ������ }
  Result := inherited IsCellReadOnly(Cell) or IsReadOnlyField(Columns[Cell.Col].Field);
end;

function TCustomDBGridView.IsEvenRow(Cell: TGridCell): Boolean;
begin
  { ����������� ��������� ����� �������� ������ ��� ���������� ������,
    � ������� ����������������� �������� (�������� Paradox, ClientDataSet) }
  if DataLink.Active and (DataLink.DataSet <> nil) and DataLink.DataSet.IsSequenced then
    Result := DataLink.DataSet.RecNo mod 2 <> 0
  else
    Result := inherited IsEvenRow(Cell);
end;

function TCustomDBGridView.IsRowHighlighted(Row: Integer): Boolean;
begin
  if (not MultiSelect) or (Row < 0) or (Rows.Count = 0) then
    Result := inherited IsRowHighlighted(Row)
  else
    Result := IsRowMultiSelected(Row);
end;

function TCustomDBGridView.IsRowMultiselected(Row: Integer): Boolean;
var
  OldActive: Integer;
begin
  if DataLink.Active and (Row >= 0) and
    ((FSelectedRows.Count > 1) or (Row <> CellFocused.Row)) then
  begin
    OldActive := DataLink.ActiveRecord;
    try
      DataLink.ActiveRecord := Row;
      Result := FSelectedRows.CurrentRowSelected;
    finally
      DataLink.ActiveRecord := OldActive;
    end;
  end
  else
    Result := False;
end;

procedure TCustomDBGridView.SetEditText(Cell: TGridCell; var Value: string);
begin
  { ������������� ����� ����� ������ � ������� ������ �������������� }
  if IsCellEqual(Cell, EditCell) and DataLink.Active and EditCanModify(Cell) and
    (Edit <> nil) then
  begin
    Edit.Text := Value;
    { SetEditText ���������� ������������� ��� ����� ������� ������ ���
      �� ���������� �������������� - ��������� �������� ������ }
    DataLink.UpdateData;
  end;
end;

procedure TCustomDBGridView.Resize;
begin
  UpdateRowCount;
  UpdateCursorPos(False);
  UpdateScrollPos;
  inherited;
end;

procedure TCustomDBGridView.UpdateData;
var
  CField: TField;
  Text: string;
  Action: TDBGridDataAction;
begin
  { ���� ���������� �������� ���������� ������������ � ������� ������ �������,
    �� � ��������� ������� ����� ������ EditField.Text := Text ������ ��
    EditField ������������ (�.�. ������� ������ �����), � ��� ���� ���������
    ������ �� ������������� ���� ��� ������ DataFieldUpdated() }
  CField := EditField;
  { ������������� ����� �������� ���� ����� ������ ���� ����� ���� ��
    ��������� ������ � �������� ���� �������� ��������� }
  if DataLink.Active and (DataLink.InUpdateData <> 0) and (not ReadOnly) and
    (CField <> nil) and (not IsReadOnlyField(CField)) and (Edit <> nil) then
  begin
    try
      { �.�. � ������� SetEditText ����� ���� ����������� ������� ������
        ������ � ��������, �� � ���� ���� ���������� ��� ������������
        ��������, � �� �� ������ ����� }
      Text := Edit.Text;
      inherited SetEditText(EditCell, Text);
      { ��������� �������� ���� }
      SetFieldText(CField, Text);
    except
      on E: Exception do
      begin
        { ����� ���������� ���������� ������ ������� ������ � ������� }
        UpdateCursorPos(True);
        { ������� (����� EAbort) }
        if not (E is EAbort) then
        begin
          Action := gdaFail;
          DataUpdateError(E, Action);
        end
        else
          Action := gdaAbort;
        { ��������� ���������� }
        if Action = gdaFail then raise;
        if Action = gdaAbort then SysUtils.Abort;
      end;
    end;
    { ������� �� ��������� ���� }
    DataFieldUpdated(CField);
  end;
end;

procedure TCustomDBGridView.UpdateEditText;
begin
  if Datalink.Active then FDataLink.UpdateData;
end;

procedure TCustomDBGridView.ApplyEdit;
begin
  { �� ���������� �������������� ������������� ��������� SetEditText,
    ������ �������� ���������� ����� ���������� ��������� ������ }
  inherited;
end;

procedure TCustomDBGridView.CancelEdit;
begin
  { ��� ������ �������������� ���������� ����� �������������� ��������
    ���� ��������� }
  DataLink.Reset;
  inherited;
end;

procedure TCustomDBGridView.CancelOrUpdateData;
begin
  if Datalink.Active then
    with Datalink.Dataset do
      if (State = dsInsert) and (not Modified) and (not Datalink.FModified) then
        Cancel
      else
        DataLink.UpdateData;
end;

function TCustomDBGridView.GetGridRect: TRect;
begin
  Result := inherited GetGridRect;
  { ����� �� ������� �������� ��������� }
  if ShowIndicator and (FContextPopup = 0) then Inc(Result.Left, GetIndicatorWidth);
end;

function TCustomDBGridView.GetHeaderRect: TRect;
begin
  Result := inherited GetHeaderRect;
  { ����� �� ������� �������� ��������� }
  if ShowIndicator and (FContextPopup = 0) then Inc(Result.Left, GetIndicatorWidth);
end;

function TCustomDBGridView.GetIndicatorHeaderRect: TRect;
begin
  { ������������� ���������� ����� �� ��������� }
  Result := GetHeaderRect;
  Result.Right := Result.Left;
  Result.Left := Result.Left - GetIndicatorWidth;
end;

function TCustomDBGridView.GetIndicatorFixedRect: TRect;
begin
  { ������������� ���������� ����� �� ����� ������� }
  Result := GetGridRect;
  Result.Right := Result.Left;
  Result.Left := Result.Left - GetIndicatorWidth;
end;

function TCustomDBGridView.GetIndicatorImage(DataRow: Integer): Integer;
begin
  Result := -1;
  if DataRow = DataLink.ActiveRecord then
  begin
    { �������� ��� ������� ������: ������, �������������� ��� ������� }
    Result := 0;
    if DataLink.DataSet <> nil then
      case DataLink.DataSet.State of
        dsEdit: Result := 1;
        dsInsert: Result := 2;
      end;
  end
  else if IsRowHighlighted(DataRow) then
  begin
    { �������� �������������� ��������� }
    Result := 3;
  end;
  { ���������� ������������ }
  if Assigned(FOnGetIndicatorImage) then FOnGetIndicatorImage(Self, DataRow, Result);
end;

function TCustomDBGridView.GetIndicatorImageRect(DataRow: Integer): TRect;
begin
  { ������������� �������� ���������� ��� ��������� c���� }
  Result := GetIndicatorFixedRect;
  Result.Top := GetRowTopBottom(DataRow).Top;
  Result.Bottom := GetRowTopBottom(DataRow).Bottom;
end;

function TCustomDBGridView.GetIndicatorWidth: Integer;
begin
  Result := FIndicatorWidth;
  if Result < 1 then Result := GetSystemMetrics(SM_CXHSCROLL);
end;

procedure TCustomDBGridView.LockLayout;
begin
  LockUpdate;
  Inc(FLayoutLock);
  if FLayoutLock = 1 then Columns.BeginUpdate;
end;

procedure TCustomDBGridView.LockScroll;
begin
  Inc(FScrollLock);
  if FScrollLock = 1 then
  begin
    FScrollCell := CellFocused;
    FScrollSelected := CellSelected;
  end;
end;

procedure TCustomDBGridView.MakeCellVisible(Cell: TGridCell; PartialOK: Boolean);
begin
  { �.�. ������������ ����������� �� ������� �������������� �� ����
    ����������� �� ������� ��������� ������, �� ������� ������� ������,
    ����������� �� �� ������� ������, ������ }
  if Cell.Row = CellFocused.Row then inherited MakeCellVisible(Cell, PartialOK);
end;

procedure TCustomDBGridView.SetCursor(Cell: TGridCell; Selected, Visible: Boolean);
var
  IC: TGridCell;
begin
  IC := CellFocused;
  { ���� �������� ������� �����������, �� ������ ���������� ����� ��������� }
  if (FScrollLock <> 0) and (FCursorFromDataSet = 0) then
  begin
    FScrollCell := Cell;
    FScrollSelected := Selected;
    Exit;
  end;
  { ������������ ����������� �� ������� �������������� ������ ���
    ����������� �� ������� ��������� ������ }
  if FCursorFromDataSet = 0 then Cell.Row := CellFocused.Row;
  { ������� ������ }
  inherited SetCursor(Cell, Selected, Visible);
end;

procedure TCustomDBGridView.UndoEdit;
begin
  { ���� ���� ��������, �� �������� ��������� }
  if DataLink.FModified then DataLink.Reset;
end;

procedure TCustomDBGridView.UnLockLayout(CancelChanges: Boolean);
begin
  if FLayoutLock = 1 then
  begin
    if not CancelChanges then UpdateLayout;
    Columns.EndUpdate;
  end;
  Dec(FLayoutLock);
  UnlockUpdate(False);
end;

procedure TCustomDBGridView.UnLockScroll(CancelScroll: Boolean);
begin
  Dec(FScrollLock);
  { ��������� ��������� ������ }
  if (FScrollLock = 0) and ((not IsCellEqual(FScrollCell, CellFocused)) or
    (FScrollSelected <> CellSelected)) then
  begin
    { ������������� ����� �� ������ }
    SetCursor(GridCell(FScrollCell.Col, CellFocused.Row), FScrollSelected, True);
    { �������� �������� ������ }
    if (not CancelScroll) and (FScrollCell.Row <> CellFocused.Row) then
    begin
      if (not DataLink.Active) or (DataLink.DataSet = nil) then Exit;
      DataLink.MoveBy(FScrollCell.Row - CellFocused.Row);
    end;
  end;
end;

procedure TCustomDBGridView.UpdateCursorPos(ShowCursor: Boolean);
var
  Cell: TGridCell;
begin
  Inc(FCursorFromDataSet);
  try
    { ��������� ���������� ��������� }
    if DataLink.Active then
    begin
      Cell.Col := CellFocused.Col;
      Cell.Row := DataLink.ActiveRecord;
    end
    else
      Cell := GridCell(0, 0);
    { ������ ������ �� ������� ������ }
    SetCursor(Cell, CellSelected, ShowCursor);
  finally
    Dec(FCursorFromDataSet);
  end;
end;

procedure TCustomDBGridView.UpdateLayout;
var
  I: Integer;
  List: TList;
  Column: TDBGridColumn;

  procedure GetFields(Fields: TFields);
  var
    I: Integer;
  begin
    for I := 0 to Fields.Count - 1 do
    begin
      List.Add(Fields[I]);
      if Fields[I].DataType in [ftADT, ftArray] then
        GetFields((Fields[I] as TObjectField).Fields);
    end;
  end;

begin
  if ([csLoading, csDestroying] * ComponentState) <> [] then Exit;
  { ���� ������������ ������� �� ��������, �� ����������� �� }
  if FDefaultLayout then
  begin
    if DataLink.Active and (DataLink.DataSet <> nil) then
    begin
      List := TList.Create;
      try
        { �������� ������ ���� ����� ��������� ������ }
        GetFields(DataLink.DataSet.Fields);
        { ���������� ���������� ������� � ���������� ����� ���������
          (�������, ����� ������ �������� ������ ������� � ���������
          ��� ������, �� ����� �������� ����� ���� AV � Delphi ���
          �������������� ������� � Design mode) }
        while (List.Count > 0) and (Columns.Count < List.Count) do Columns.Add;
        while (Columns.Count > 0) and (Columns.Count > List.Count) do Columns[0].Free;
        { ���������� ���� ��������� ������� � �������� �� ��������� }
        for I := 0 to List.Count - 1 do
        begin
          Column := Columns[I];
          Column.FieldName := TField(List[I]).FullName;
          Column.Field := nil;
          Column.RestoreDefaults;
          Column.FDefaultColumn := True;
        end;
      finally
        List.Free;
      end;
    end
    else
      Columns.Clear;
    { �������������� ��������� }
    Header.FullSynchronizing := True;
    Header.Synchronized := True;
  end
  else
    { ���������� ������ �� ���� ������������ ������� }
    for I := 0 to Columns.Count - 1 do
    begin
      Column := Columns[I];
      Column.Field := nil;
      { ���� ��� ������� �� ���������, �� ��������� �� ���� }
      if Column.DefaultColumn then
      begin
        Column.RestoreDefaults;
        Column.FDefaultColumn := True;
      end;
    end;
  { ����������� ���������� ������������� }
  Fixed.SetCount(Fixed.Count);
  { ��������� ���������� �����, ��������� ������� }
  UpdateRowCount;
  UpdateCursorPos(True);
end;

procedure TCustomDBGridView.UpdateRowCount;

  procedure SetRowsCount(Value: Integer);
  begin
    with TDBGridRows(Rows) do
    begin
      Inc(FRowsFromGrid);
      try
        SetCount(Value);
      finally
        Dec(FRowsFromGrid);
      end;
    end;
  end;

begin
  if DataLink.Active then
  begin
    { ������ ������ DataLink ������������� ������ ���������� �������
      ������� ����� }
    DataLink.BufferCount := GetGridHeight div Rows.Height;
    SetRowsCount(DataLink.RecordCount);
  end
  else
    SetRowsCount(0);
end;

procedure TCustomDBGridView.UpdateSelection(var Cell: TGridCell; var Selected: Boolean);
begin
  inherited;
  { ���������� ������ ������� ������ ������ �������������� ������� ������
    ��������� ������, �������� �� �� ����� ������� }
  Cell.Row := DataLink.ActiveRecord;
end;

end.

