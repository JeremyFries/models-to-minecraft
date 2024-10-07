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
Database := "blocks"         ; Name of the database to work with
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
MsgBox Press Enter to Start Script
file := "C:\Users\fries\Downloads\granblue-fantasy-mcdonalds\source\model\model.obj"
FileRead, objData, C:\Users\fries\Downloads\granblue-fantasy-mcdonalds\source\model\model.obj
MsgBox % objData
; Split data into individual lines
objLines := StrSplit(objData, "`n")
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
; Initialize vertex and face arrays
vertices := []
faces := []
facetextures := []
textures := []
blocks := []
areas := []
areaAvg := 0
; Parse data into arrays
i := 0
l := 0
loop, read, C:\Users\fries\Downloads\granblue-fantasy-mcdonalds\source\model\model.obj
{
    ; Split line into words
    words := StrSplit(A_LoopReadLine, " ")
    ; Parse vertex data
    if (words[1] = "v")
    {
        x := words[2]
        y := words[3]
        z := words[4]
        ;MsgBox % x ", " y ", " z
        ; Add vertex to array
        vertices.Push([x, y, z])
        ;MsgBox % vertices[i][1] ", " vertices[i][2] ", " vertices[i][3]
    }
    ; Parse texture data
    if (words[1] = "vt")
    {
        tx := (words[2] * w)
        ty := (words[3] * h)
        if (tx > w)
            tx := w
        if (ty > h)
            ty := h
        textures.Push([tx, ty])
        ;Msgbox % "Height and width are:" h ", " w
        ;MsgBox % tx ", " ty "`nPixels: " jx ", " jy 
    }
    ; Parse face data
    if (words[1] = "f")
    {
        ;MsgBox % A_LoopReadLine
        l := l + 1
        words := StrSplit(words[2]"/"words[3]"/"words[4]"/", "/")
        ;MsgBox % words[1]
        v1 := words[1]
        v2 := words[3]
        v3 := words[5]
        t1 := words[2]
        t2 := words[4]
        t3 := words[6]

        ;MsgBox % v1 ", " v2 ", " v3
        ; Add face to array
        faces.Push([v1, v2, v3, t1, t2, t3])
        facetextures.Push([t1, t2, t3])
        ;MsgBox % "The faces are " faces[l][1] ", " faces[l][2] ", " faces[l][3] "`nAnd the face textures are " facetextures[l][1] ", " facetextures[l][2] ", " facetextures[l][3]
    }

}
for i in textures
    {
    if (textures[i][1] > 4096 or textures[i][2] > 4096) 
        msgbox % textures[i][1] ", " textures[i][2] "`nw, h " w ", " h "`n" i
    }
; Find model height
modelMaxY := vertices[1][2]
modelMinY := vertices[1][2]
for i in vertices
{
    if (vertices[i][2] > modelMaxY)
        modelMaxY := vertices[i][2]
    if (vertices[i][2] < modelMinY)
        modelMinY := vertices[i][2]
}
modelHeight := modelMaxY - modelMinY
; Establish desired height (height for structure in minecraft)
desiredHeight := 30
scaleFactor := desiredHeight / modelHeight
;msgbox % vertices[1][1]
; Reassign vertices to desired scale
for i in vertices
{    
    for l in vertices[i]
    {
        vertices[i][l] := vertices[i][l] * scaleFactor
        if (l = 2)
            vertices[i][l] := vertices[i][l] - scaleFactor * modelMinY
    }
}

for i in faces
{
;msgbox % "xyz are " faces[i][1] ", " faces[i][2] ", " faces[i][3] "`ntxyz are " faces[i][4] ", " faces[i][5] ", " faces[i][6]
; Get vertex data for each point in the face
progress := i * 100 / faces.Length()
if (Mod(i, 30) = 0)
    ToolTip % Round(progress, 2) "%"
v1 := vertices[faces[i][1]]
v2 := vertices[faces[i][2]]
v3 := vertices[faces[i][3]]
t1 := textures[faces[i][4]]
t2 := textures[faces[i][5]]
t3 := textures[faces[i][6]]
; Retrieve dimensions for cube that triangle lies within
minX := Floor(Min(v1[1], v2[1], v3[1]))
maxX := Ceil(Max(v1[1], v2[1], v3[1]))
minY := Floor(Min(v1[2], v2[2], v3[2]))
maxY := Ceil(Max(v1[2], v2[2], v3[2]))
minZ := Floor(Min(v1[3], v2[3], v3[3]))
maxZ := Ceil(Max(v1[3], v2[3], v3[3]))
;msgbox % minX
x := minX - 1
y := minY - 1
z := minZ - 1
; Establish normal vector and retrieve equation of plane containing triangle
v21 := []
v31 := []
v32 := []
n := []
loop, 3
    {
    v21[A_Index] := v2[A_Index] - v1[A_Index]
    v31[A_Index] := v3[A_Index] - v1[A_Index]
    v32[A_Index] := v3[A_Index] - v2[A_Index]
    }
a := v21[2] * v31[3] - v21[3] * v31[2]
b := v21[3] * v31[1] - v21[1] * v31[3]
c := v21[1] * v31[2] - v21[2] * v31[1]
d := -(a * v1[1] + b * v1[2] + c * v1[3])
an := a / (a ** 2 + b ** 2 + c **2) ** 0.5
bn := b / (a ** 2 + b ** 2 + c **2) ** 0.5
cn := c / (a ** 2 + b ** 2 + c **2) ** 0.5
bigarea := 0.5 * (a ** 2 + b ** 2 + c **2) ** 0.5
;msgbox % "v2 is " v2[1] ", " v2[2] ", " v2[3] "`nv1 is " v1[1] " " v1[2] " " v1[3] "v is " v3[1] ", " v3[2] ", " v3[3] "`nand v2 - v1 is" v21[1] " " v21[2] " " v21[3] "`na is " a "`nb is " b "`nc is " c "`nd is " d 
times := Ceil(maxX - minX + 1) * Ceil(maxY - minY + 1) * Ceil(maxZ - minZ + 1)
;msgbox % "`nx ranges from " minX " to " maxX "`ny ranges from " minY " to " maxY "`nz ranges from " minZ " to " maxZ "`n this should run " times " times"

loop
{
    x := minX + A_Index - 1 
    if ((x = maxX and minX < maxX) or (x > maxX))
        break
    loop
    {
        y := minY + A_Index - 1 
        if ((y = maxY and minY < maxY) or (y > maxY))
            {
            y := minY
            break 
            }
        loop
            {
            if ((z = maxZ and minZ < maxZ) or (z > maxZ))
                {
                z := minZ
                break
                }
            z := minZ + A_Index - 1
            r1 := a * x + b * (y + 1) + c * (z + 1) + d
            r2 := a * x + b * (y + 1) + c * z + d
            r3 := a * x + b * y + c * (z + 1) + d
            r4 := a * x + b * y + c * z + d
            r5 := a * (x + 1) + b * (y + 1) + c * (z + 1) + d
            r6 := a * (x + 1) + b * (y + 1) + c * z + d
            r7 := a * (x + 1) + b * y + c * (z + 1) + d
            r8 := a * (x + 1) + b * y + c * z + d
            ;MsgBox % r1 "`n" r2 "`n" r3 "`n" r4 "`n" r5 "`n" r6 "`n" r7 "`n" r8 "`n" 
            if (r1 > 0 and r2 > 0 and r3 > 0 and r4 > 0 and r5 > 0 and r6 > 0 and r7 > 0 and r8 > 0) or (r1 < 0 and r2 < 0 and r3 < 0 and r4 < 0 and r5 < 0 and r6 < 0 and r7 < 0 and r8 < 0)
                {
                if (z = maxZ)
                    {
                    z := minZ
                    break
                    }
                continue    
                }
            
            ;Determine if triangle actually intersects
            ;First we see if the triangle's edges intersects with the voxel
            ; v21 x0+(one-x0)t ; v1[1] + (v2[1] - v1[1])t ; t = (x - v1[1]) / ()

            
            txmin21 := (x - v1[1]) / v21[1]
            txmax21 := (x + 1 - v1[1]) / v21[1]
            tymin21 := (y - v1[2]) / v21[2]
            tymax21 := (y + 1 - v1[2]) / v21[2]
            tzmin21 := (z - v1[3]) / v21[3]
            tzmax21 := (z + 1 - v1[3]) / v21[3]
            txmin31 := (x - v1[1]) / v31[1]
            txmax31 := (x + 1 - v1[1]) / v31[1]
            tymin31 := (y - v1[2]) / v31[2]
            tymax31 := (y + 1 - v1[2]) / v31[2]
            tzmin31 := (z - v1[3]) / v31[3]
            tzmax31 := (z + 1 - v1[3]) / v31[3]
            txmin32 := (x - v2[1]) / v32[1]
            txmax32 := (x + 1 - v2[1]) / v32[1]
            tymin32 := (y - v2[2]) / v32[2]
            tymax32 := (y + 1 - v2[2]) / v32[2]
            tzmin32 := (z - v2[3]) / v32[3]
            tzmax32 := (z + 1 - v2[3]) / v32[3]
            ;dot1 := (x - v1[1]) * a + (y - v1[2]) * b + (z - v1[3]) * c
            ;dot2 := (x - v2[1]) * a + (y - v2[2]) * b + (z - v2[3]) * c
            ;dot3 := (x - v3[1]) * a + (y - v3[2]) * b + (z - v3[3]) * c
            tparams := [txmin21, txmax21, txmin31, txmax31, txmin32, txmax32, tymin21, tymax21, tymin31, tymax31, tymin32, tymax32, tzmin21, tzmax21, tzmin31, tzmax31, tzmin32, tzmax32]
            ;if (!((0 <= txmin21 <= 1) or (0 <= txmax21 <= 1) or (0 <= tymin21 <= 1) or (0 <= tymax21 <= 1) or (0 <= tzmin21 <= 1) or (0 <= tzmax21 <= 1) or (0 <= txmin31 <= 1) or (0 <= txmax31 <= 1) or (0 <= tymin31 <= 1) or (0 <= tymax31 <= 1) or (0 <= tzmin31 <= 1) or (0 <= tzmax31 <= 1) or (0 <= txmin32 <= 1) or (0 <= txmax32 <= 1) or (0 <= tymin32 <= 1) or (0 <= tymax32 <= 1) or (0 <= tzmin32 <= 1) or (0 <= tzmax32 <= 1)) and !((dot1 >= 0 and dot2 >= 0 and dot3 >= 0) or (dot1 <= 0 and dot2 <= 0 and dot3 <= 0)))
                ;MsgBox % txmin21 ", " txmax21 ", " tymin21 ", " tymax21 ", " tzmin21 ", " tzmax21 " `n" txmin31 ", " txmax31 ", " tymin31 ", " tymax31 ", " tzmin31 ", " tzmax31 " `n" txmin32 ", " txmax32 ", " tymin32 ", " tymax32 ", " tzmin32 ", " tzmax32 "`n`n" dot1 ", " dot2 ", " dot3
            points := []
            for k in tparams
            {
            if tparams[k] >= 1 or tparams[k] <= 0
                continue
            u := 0
            if (Mod(k, 2) = 0)
                u := 1
            if (Mod(k,6) = 1 or Mod(k,6) = 2)
                {
                intercept := v1
                slope := v21
                }
            if (Mod(k,6) = 3 or Mod(k,6) = 4)
                {
                intercept := v1
                slope := v31
                }
            if (Mod(k,6) = 5 or Mod(k,6) = 0)
                {
                intercept := v2
                slope := v32
                }
            pointX := intercept[1] + tparams[k] * slope[1]
            pointY := intercept[2] + tparams[k] * slope[2]
            pointZ := intercept[3] + tparams[k] * slope[3]
            if (k <= 6)
                pointX := x + u
            if (k >= 7 and k <= 12)
                pointY := y + u
            if (k >= 13)
                pointZ := z + u
            if (pointX >= x and pointX <= x + 1 and pointY >= y and pointY <= y + 1 and pointZ >= z and pointZ <= z + 1)
                points.Push([pointX, pointY, pointZ])
            }
            ; Adds any vertices of the triangle itself within the points
            if (v1[1] >= x and v1[1] <= x + 1 and v1[2] >= y and v1[2] <= y + 1 and v1[3] >= z and v1[3] <= z + 1)
                points.Push([v1[1], v1[2], v1[3]])
            if (v2[1] >= x and v2[1] <= x + 1 and v2[2] >= y and v2[2] <= y + 1 and v2[3] >= z and v2[3] <= z + 1)
                points.Push([v2[1], v2[2], v2[3]])
            if (v3[1] >= x and v3[1] <= x + 1 and v3[2] >= y and v3[2] <= y + 1 and v3[3] >= z and v3[3] <= z + 1)
                points.Push([v3[1], v3[2], v3[3]])
            ; Adds intersections of the cube's edges
            edgepoints := []
            x1 := (- b * y - c * z - d) / a
            if (x1 >= x and x1 <= x + 1)
                edgepoints.Push([x1, y, z])
            x2 := (- b * (y + 1) - c * z - d) / a
            if (x2 >= x and x2 <= x + 1)
                edgepoints.Push([x2, y + 1, z])
            x3 := (- b * y - c * (z + 1) - d) / a
            if (x3 >= x and x3 <= x + 1)
                edgepoints.Push([x3, y, z + 1])
            x4 := (- b * (y + 1) - c * (z + 1) - d) / a 
            if (x4 >= x and x4 <= x + 1)
                edgepoints.Push([x4, y + 1, z + 1])           
            y1 := (- a * x - c * z - d) / b
            if (y1 >= y and y1 <= y + 1)
                edgepoints.Push([x, y1, z])
            y2 := (- a * (x + 1) - c * z - d) / b
            if (y2 >= y and y2 <= y + 1)
                edgepoints.Push([x + 1, y2, z])
            y3 := (- a * x - c * (z + 1) - d) / b
            if (y3 >= y and y3 <= y + 1)
                edgepoints.Push([x, y3, z + 1])
            y4 := (- a * (x + 1) - c * (z + 1) - d) / b
            if (y4 >= y and y4 <= y + 1)
                edgepoints.Push([x + 1, y4, z + 1])         
            z1 := (- a * x - b * y - d) / c
            if (z1 >= z and z1 <= z + 1)
                edgepoints.Push([x, y, z1])
            z2 := (- a * (x + 1) - b * y - d) / c
            if (z2 >= z and z2 <= z + 1)
                edgepoints.Push([x + 1, y, z2])
            z3 := (- a * x - b * (y + 1) - d) / c
            if (z3 >= z and z3 <= z + 1)
                edgepoints.Push([x, y + 1, z3])
            z4 := (- a * (x + 1) - b * (y + 1) - d) / c
            if (z4 >= z and z4 <= z + 1)
                edgepoints.Push([x + 1, y + 1, z4])
            for k in edgepoints
            {
            ;edgepoints[k][1]
            Dt := v1[1] * (v2[2] * v3[3] - v2[3] * v3[2]) + v1[2] * (v2[3] * v3[1] - v2[1] * v3[3]) + v1[3] * (v2[1] * v3[2] - v2[2] * v3[1])
            Dx := edgepoints[k][1] * (v2[2] * v3[3] - v2[3] * v3[2]) + edgepoints[k][2] * (v2[3] * v3[1] - v2[1] * v3[3]) + edgepoints[k][3] * (v2[1] * v3[2] - v2[2] * v3[1])
            Dy := v1[1] * (edgepoints[k][2] * v3[3] - edgepoints[k][3] * v3[2]) + v1[2] * (edgepoints[k][3] * v3[1] - edgepoints[k][1] * v3[3]) + v1[3] * (edgepoints[k][1] * v3[2] - edgepoints[k][2] * v3[1])
            Dz := v1[1] * (v2[2] * edgepoints[k][3] - v2[3] * edgepoints[k][2]) + v1[2] * (v2[3] * edgepoints[k][1] - v2[1] * edgepoints[k][3]) + v1[3] * (v2[1] * edgepoints[k][2] - v2[2] * edgepoints[k][1])
            u := Dx / Dt
            v := Dy / Dt
            w := Dz / Dt
            ;msgbox % "u = " u "`nv = " v "`nw = " w "`n`nu + v + w =" u + v + w
            if (u >= 0 and v >= 0 and w >= 0)
                points.Push([edgepoints[k][1], edgepoints[k][2], edgepoints[k][3]])
            }
            ;if (x <= 30 and x >= 0 and y <= 30 and y >= 0 and z <= 30 and z >= 0)
            ;m += 1
            ;if (points.Length() < 3 and points.Length() > 0)
            ;if (x = -4)
                ;msgbox % "face #" m "`nfrom x: " x " to " x + 1 ", y: " y " to " y + 1 ", z: " z " to " z + 1 "`n`nv1: " v1[1] ", " v1[2] ", " v1[3] "`nv2: " v2[1] ", " v2[2] ", " v2[3] "`nv3: " v3[1] ", " v3[2]  ", " v3[3] "`n`n" a " * x + " b " * y + " c " * z + " d " = 0" "`n`n" points[1][1] " " points[1][2] " " points[1][3] "`n" points[2][1] " " points[2][2] " " points[2][3] "`n" points[3][1] " " points[3][2] " " points[3][3] "`n" points[4][1] " " points[4][2] " " points[4][3] "`n" points[5][1] " " points[5][2] " " points[5][3] "`n" points[6][1] " " points[6][2] " " points[6][3] "`n" points[7][1] " " points[7][2] " " points[7][3] "`n" points[8][1] " " points[8][2] " " points[8][3] "`n" points[9][1] " " points[9][2] " " points[9][3] "`n"
           ;If none of the edges intersect, we check if the whole plane is in the triangle 
            if (points.Length() = 0)
            {
                if (z = maxZ)
                    {
                    z := minZ
                    break
                    }
                continue        
                ;Msgbox % px ", " py ", " pz "`n" "is within " x ", " y ", " z
            }
            ;if points.Length() = 0 ;and !((dot1 >= 0 and dot2 >= 0 and dot3 >= 0) or (dot1 <= 0 and dot2 <= 0 and dot3 <= 0))
                ;msgbox % dot1 ", " dot2 ", " dot3
            ;Determine the centroid
            cv := [0, 0, 0]
            for i in points
                {
                cv[1] += points[i][1]
                cv[2] += points[i][2]
                cv[3] += points[i][3]
                }
            cv[1] /= points.Length()
            cv[2] /= points.Length()
            cv[3] /= points.Length()
            ;Find the barycentric coordinates for the centroid
            cv1 := []
            cv2 := []
            cv3 := []
            loop, 3
            {
            cv1[A_Index] := v1[A_Index] - cv[A_Index]
            cv2[A_Index] := v2[A_Index] - cv[A_Index]
            cv3[A_Index] := v3[A_Index] - cv[A_Index]
            }
            bc := []
            bc[1] := (0.5 * ((cv2[2] * cv3[3] - cv2[3] * cv3[2]) ** 2 + (cv2[3] * cv3[1] - cv2[1] * cv3[3]) ** 2 + (cv2[1] * cv3[2] - cv2[2] * cv3[1]) ** 2) ** 0.5) / bigarea
            bc[2] := (0.5 * ((cv1[2] * cv3[3] - cv1[3] * cv3[2]) ** 2 + (cv1[3] * cv3[1] - cv1[1] * cv3[3]) ** 2 + (cv1[1] * cv3[2] - cv1[2] * cv3[1]) ** 2) ** 0.5) / bigarea
            bc[3] := (0.5 * ((cv2[2] * cv1[3] - cv2[3] * cv1[2]) ** 2 + (cv2[3] * cv1[1] - cv2[1] * cv1[3]) ** 2 + (cv2[1] * cv1[2] - cv2[2] * cv1[1]) ** 2) ** 0.5) / bigarea
            ;msgbox % bc[1] ", " bc[2] ", " bc[3] "`n" bc[1] + bc[2] + bc[3]
            if (bc[1] + bc[2] + bc[3] > 1.000009)
                msgbox % "bc sum is" bc[1] + bc[2] + bc[3] "`nbc is " bc[1] ", " bc[2] ", " bc[3] "`nfrom x: " x " to " x + 1 ", y: " y " to " y + 1 ", z: " z " to " z + 1 "`n`nv1: " v1[1] ", " v1[2] ", " v1[3] "`nv2: " v2[1] ", " v2[2] ", " v2[3] "`nv3: " v3[1] ", " v3[2]  ", " v3[3] "`n`n" a " * x + " b " * y + " c " * z + " d " = 0" "`n`ncentroid: " cv[1] ", " cv[2] ", " cv[3] "`narea: " area "`n`n" points[1][1] " " points[1][2] " " points[1][3] "`n" points[2][1] " " points[2][2] " " points[2][3] "`n" points[3][1] " " points[3][2] " " points[3][3] "`n" points[4][1] " " points[4][2] " " points[4][3] "`n" points[5][1] " " points[5][2] " " points[5][3] "`n" points[6][1] " " points[6][2] " " points[6][3] "`n" points[7][1] " " points[7][2] " " points[7][3] "`n" points[8][1] " " points[8][2] " " points[8][3] "`n" points[9][1] " " points[9][2] " " points[9][3] "`n"
            textureX := Round(bc[1] * t1[1] + bc[2] * t2[1] + bc[3] * t3[1])
            textureY := Round(bc[1] * t1[2] + bc[2] * t2[2] + bc[3] * t3[2])
            ;msgbox % textureX ", " textureY
            ;Get Minecraft block from pixel color
            pixColor := Gdip_GetLockBitPixel(scan, textureX, textureY, stride)
            pixColor := Format("{:X}", pixColor)
            r := Format("{:d}", "0x" subStr(pixColor,3,2))
            g := Format("{:d}", "0x" subStr(pixColor,5,2))
            bb := Format("{:d}", "0x" subStr(pixColor,7,2))
		    SQL := "select block_name from rgb order by (r - """ r "%"") * 0.3 * (r - """ r "%"") * 0.3 + (g - """ g "%"") * 0.59 * (g - """ g "%"") * 0.59 + (b - """ b "%"") * 0.11 * (b - """ bb "%"") * 0.11 asc limit 1"
            if (My_DB.Query(SQL) = MySQL_SUCCESS) 
                {
                Result := My_DB.GetResult()
                SB_SetText("ListView has been updated: " . Result.Columns . " columns - " . Result.Rows . " rows.")
                }
            ;msgbox % Result[1][1]
            ;msgbox % sortedpoints[1][1] " " sortedpoints[4][1] ;" " sortedpoints[i][3] "`ni = " i
            ;StringSplit, sortedangles, angles, [Space]
            ;msgbox % "angles are " sortedangles[1] " " sortedangles[2] " " sortedangles[3] " " sortedangles[4] " " sortedangles[5] "`nnum is " numerator "`ndenom is " denominator
            ;msgbox % "face #" m "`nfrom x: " x " to " x + 1 ", y: " y " to " y + 1 ", z: " z " to " z + 1 "`n`nv1: " v1[1] ", " v1[2] ", " v1[3] "`nv2: " v2[1] ", " v2[2] ", " v2[3] "`nv3: " v3[1] ", " v3[2]  ", " v3[3] "`n`n" a " * x + " b " * y + " c " * z + " d " = 0" "`n`ncentroid: " cv[1] ", " cv[2] ", " cv[3] "`narea: " area "`n`n" points[1][1] " " points[1][2] " " points[1][3] "`n" points[2][1] " " points[2][2] " " points[2][3] "`n" points[3][1] " " points[3][2] " " points[3][3] "`n" points[4][1] " " points[4][2] " " points[4][3] "`n" points[5][1] " " points[5][2] " " points[5][3] "`n" points[6][1] " " points[6][2] " " points[6][3] "`n" points[7][1] " " points[7][2] " " points[7][3] "`n" points[8][1] " " points[8][2] " " points[8][3] "`n" points[9][1] " " points[9][2] " " points[9][3] "`n"
            blocks.Push([x, y, z, Result[1][1]]) ;add to this
            ;msgbox % txmin21 " " txmax 
            ;ymin21 := 
    
            ;msgbox % x ", " y ", " z
            }
    }   
}
;MsgBox % v1[1] ", " v1[2] ", " v1[3] "`n" v2[1] ", " v2[2] ", " v2[3] "`n" v3[1] ", " v3[2] ", " v3[3]
}
oldblocknum := blocks.Length()
msgbox % "Time for the trim"
blockslength := blocks.Length()
for i in blocks
    {
    progress := i * 100 / blockslength
    if (Mod(i, 30) = 0)
        ToolTip % Round(progress, 2) "%"  ; for n > i
    for n in blocks
        {
        if (n <= i)
            continue   
        if (blocks[i][1] = blocks[n][1] and blocks[i][2] = blocks[n][2] and blocks[i][3] = blocks[n][3] and i != n)
            {
            if (blocks[i][5] >= blocks[n][5])
                blocks.RemoveAt(n)
            if (blocks[i][5] < blocks[n][5])
                blocks.RemoveAt(i)
            }
        }
    }
msgbox % blocks.Length() "`n" blocks.Length() / oldblocknum 
msgbox "Press Enter to Begin Generation"
loop, 2
{
for i in blocks
    {
    Clipboard := "setblock " blocks[i][1] " " blocks[i][2] - 64 " " blocks[i][3] " " blocks[i][4]
    Send /
    sleep 70
    Send ^v
    Send {Enter}
    }
}
}
; Output structure data to file
FileDelete, structure.txt
FileAppend, %structure%, structure.txt
Gdip_UnlockBits(pBitmap, bitmapData)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
Return

*^2::
Reload
Return

*^4::
msgbox % progress
Return

*3::
ExitApp
}

