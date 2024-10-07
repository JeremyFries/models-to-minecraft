#NoEnv
#SingleInstance Force
SetBatchLines, -1
ListLines, Off
#Include Class_MySQLAPI.ahk ; pull from local directory
OnExit, AppExit
Global MySQL_SUCCESS := 0
global script :=
{

UserID := "root"           ; User name - must have privileges to create databases
UserPW := "admin"           ; User''s password
Server := "localhost"      ; Server''s host name or IP address
Database := "wallmosaic"         ; Name of the database to work with
DropDatabase := False      ; DROP DATABASE
DropTable := False         ; DROP TABLE Address
; ======================================================================================================================
; Connect to MySQL
; ======================================================================================================================
; Instantiate a MYSQL object
If !(My_DB := New MySQLAPI)
   ExitApp
; Get the version of libmysql.dll
ClientVersion := My_DB.Get_Client_Info()
; Connect to the server, Host can be a hostname or IP address
If !My_DB.Connect(Server, UserID, UserPW) {  ; Host, User, Password
   MsgBox, 16, MySQL Error!, % "Connection failed!`r`n" . My_DB.ErrNo() . " - " . My_DB.Error()
   ExitApp
}
; ======================================================================================================================
; CREATE DADABASE Test
; ======================================================================================================================
If (DropDatabase)
   My_DB.Query("DROP DATABASE IF EXISTS " . DataBase)
SQL := "CREATE DATABASE IF NOT EXISTS " . Database . " DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_bin"
My_DB.Query(SQL)
; ======================================================================================================================
; Select the database as default
; ======================================================================================================================
My_DB.Select_DB(Database)
; ======================================================================================================================
; CREATE TABLE Address
; ======================================================================================================================
If (DropTable)
   My_DB.Query("DROP TABLE IF EXISTS Address")
SQL := "CREATE TABLE IF NOT EXISTS Address ( "
     . "Name VARCHAR(50) NULL, "
     . "Address VARCHAR(50) NULL, "
     . "City VARCHAR(50) NULL, "
     . "State VARCHAR(2) NULL, "
     . "Zip INT(5) ZEROFILL NULL, "
     . "PRIMARY KEY (Name) )"
My_DB.Query(SQL)
; ======================================================================================================================
; Fill ListView with existing addresses from database
; ======================================================================================================================
Return
; ======================================================================================================================
; GUI was closed
; ======================================================================================================================
GuiClose:
ExitApp
AppExit:
   My_DB := ""
ExitApp





*^1::
{
MsgBox Press Enter to Begin Generation
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include Gdip_all.ahk
; download from https://www.autohotkey.com/boards/viewtopic.php?t=6517

filename := "C:\Users\fries\Downloads\granblue-fantasy-mcdonalds\source\model\model.jpg"

pToken := Gdip_Startup()
pBitmap := Gdip_CreateBitmapFromFile(filename)
Gdip_GetImageDimensions(pBitmap, w, h)
Gdip_LockBits(pBitmap, 0, 0, w, h, stride, scan, bitmapData)
loop, 2
{
loop, % h {
	y := h - A_Index
	;MsgBox % y
	loop, % w {
		x := w - A_Index
		pixColor := Gdip_GetLockBitPixel(scan, x, y, stride)
        pixColor := Format("{:X}", pixColor)
        r := Format("{:d}", "0x" subStr(pixColor,3,2))
        g := Format("{:d}", "0x" subStr(pixColor,5,2))
        b := Format("{:d}", "0x" subStr(pixColor,7,2))
		SQL := "select block_name from rgb order by (r - """ r "%"") * 0.3 * (r - """ r "%"") * 0.3 + (g - """ g "%"") * 0.59 * (g - """ g "%"") * 0.59 + (b - """ b "%"") * 0.11 * (b - """ b "%"") * 0.11 asc limit 1"
   If (My_DB.Query(SQL) = MySQL_SUCCESS) {
      Result := My_DB.GetResult()
      SB_SetText("ListView has been updated: " . Result.Columns . " columns - " . Result.Rows . " rows.")
   }
z := h - y - 64
t := x + 2100
MsgBox % "setblock " x ", " 0 ", " h - y ", " Result.1.1
Clipboard := "setblock " t " " z " " 0 " " Result.1.1
Send /
sleep 70
Send ^v
Send {Enter}
;MsgBox % r ", " g ", " b
;MsgBox % Result.1.1

	}
}
}
Gdip_UnlockBits(pBitmap, bitmapData)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
return

Command1(s1, s2) {
	MsgBox, % "Command 1`nSetting1: " s1 "`nSetting2: " s2
}

Command2(s1, s2) {
	MsgBox, % "Command 2`nSetting1: " s1 "`nSetting2: " s2
}
}
; and so on...
*^2::reload
Return

*^3::ExitApp
}