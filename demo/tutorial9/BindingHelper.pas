(*

    Daraja HTTP Framework
    Copyright (C) Michael Justin

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


    You can be released from the requirements of the license by purchasing
    a commercial license. Buying such a license is mandatory as soon as you
    develop commercial activities involving the Daraja framework without
    disclosing the source code of your own applications. These activities
    include: offering paid services to customers as an ASP, shipping Daraja
    with a closed source product.

*)

unit BindingHelper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  Classes;

function Bind(Context, FileName: string; Params: TStrings): string;

implementation

uses
  SysUtils;

function Bind(Context, FileName: string; Params: TStrings): string;
var
  SL : TStrings;
  Folder: string;
  I: Integer;
  Name, Value, Search: string;
begin
  if Context = '' then Folder := 'ROOT' else Folder := Context;

  SL := TStringList.Create;
    try
      SL.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'webapps/'
       + Folder + '/' + FileName);
      Result := SL.Text;
    finally
      SL.Free;
    end;

  Result := StringReplace(Result,
      '<dj:header/>',
      '<header>' +
      '<p></p>' +
      '</header>',
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '<dj:footer/>',
      '<footer>' +
      '<p></p>' +
      '</footer>',
      [rfReplaceAll]);

  for I := 0 to Params.Count -1 do begin
    Name := Params.Names[I]; Value := Params.Values[Name];
    Search := '#{sessionScope[' + Name + ']}';
    if Pos(Search, Result) > 0 then
      Result := StringReplace(Result, Search, Value, [rfReplaceAll])
  end;
end;

end.
