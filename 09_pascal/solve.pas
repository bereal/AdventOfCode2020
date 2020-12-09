
program day9;

type 
  input = array of int64;


function ReadInput: input;

var 
  i: integer;
  val: int64;
  data: input;

begin
  i := 0;
  repeat
    begin
      val := 0;
      Readln(val);
      if val > 0 then
        begin
          Inc(i);
          Setlength(data, i);
          data[i-1] := val;
        end;
    end;
  until EOF();
  ReadInput := data;
end;


function CheckOutlier(data: input; idx: integer): boolean;

var 
  i, j: integer;
  val, cur: int64;

begin
  if idx < 25 then
    begin
      CheckOutlier := false;
      exit
    end;
  val := data[idx];

  for i:= idx-25 to idx - 2 do
    begin
      cur := data[i];
      if cur < val then
        for j := i+1 to idx-1 do
          begin
            if data[j] + cur = val then
              begin
                CheckOutlier := false;
                exit;
              end
          end;
    end;
  checkoutlier := true;
end;


function FindOutlier(data: input): integer;

var 
  i: integer;

begin
  FindOutlier := 0;
  for i:=0 to length(data)-1 do
    begin
      if CheckOutlier(data, i) then
        begin
          FindOutlier := i;
          break;
        end;
    end;
end;


function FindOutlierSum(data: input; idx: integer): int64;

var 
  i, j: integer;
  target, sum, min, max, cur: int64;

begin
  target := data[idx];
  for i:=0 to idx-1 do
    begin
      sum := 0;
      min := data[i];
      max := data[i];
      for j:=i+1 to idx-1 do
        begin
          cur := data[j];
          sum := sum + cur;
          if cur < min then min := cur;
          if cur > max then max := cur;
          if sum = target then
            begin
              FindOutlierSum := min + max;
              exit
            end;
          if sum > target then
            break;
        end;
    end;
end;


var 
  data: input;
  outlierIdx: integer;
  outlierSum: int64;
begin
  data := ReadInput;
  outlierIdx := FindOutlier(data);
  outlierSum := FindOutlierSum(data, outlierIdx);
  writeln(data[outlierIdx], ' ', outlierSum);
end.
