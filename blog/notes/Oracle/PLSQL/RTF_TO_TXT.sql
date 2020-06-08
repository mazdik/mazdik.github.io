CREATE OR REPLACE FUNCTION Rtf2Txt(pRtf varchar2) return nvarchar2 is
  /*
  Converts RTF text to TXT format by removing headers, commands, and formatting
  */
  vPos1 int;
  vPos2 int;
  vPos3 int;
  vPos4 int;
  vTmp  int;
  vText varchar2(4000);
begin
  vText := pRtf;
  if vText is null then
    return vText;
  end if;

  -- Remove outer { and } pair
  vPos1 := instr(vText, '{', +1); -- The first {
  vPos2 := instr(vText, '}', -1); -- The last }
  if vPos1 > 0 and vPos2 > 0 then
    vText := substr(vText, vPos1 + 1, vPos2 - vPos1 - 1);
  end if;

  -- Remove inner { and } pairs
  while 1 = 1 loop
    vPos2 := instr(vText, '}', +1); -- The first }
    vPos1 := instr(vText, '{', (length(vText) - vPos2) * -1 - 1); -- The last { before the found }
    if vPos1 > 0 and vPos2 > 0 and vPos1 < vPos2 then
      vText := substr(vText, 1, vPos1 - 1) || substr(vText, vPos2 + 1, length(vText) - vPos2);
    else
      exit;
    end if;
  end loop;

  -- Cleaning up
  vText := replace(vText, '\pard', '');
  vText := replace(vText, chr(13), '');
  vText := replace(vText, chr(10), '');
  vText := replace(vText, '\par', chr(13));
  while length(vText) > 0 and substr(vText, 1, 1) IN (' ', CHR(13), CHR(10)) loop
    vText := substr(vText, 2, length(vText) - 1);
  end loop;
  while length(vText) > 0 and substr(vText, length(vText), 1) IN (' ', CHR(13), CHR(10)) loop
    vText := substr(vText, 1, length(vText) - 1);
  end loop;

  -- Remove \ commands and replace \'XX charactercoding
  vPos2 := 1;
  while 1 = 1 loop
    vPos1 := instr(vText, '\', vPos2);
    if vPos1 = 0 then
      exit;
    end if;
    if substr(vText, vPos1 + 1, 1) = '\' then
      -- Skip \\ escape sequence, when present
      vPos2 := vPos1 + 2;
      continue;
    end if;
    if substr(vText, vPos1 + 1, 1) = '''' then
      -- Decode \' hex sequence
      vTmp  := to_number(substr(vText, vPos1 + 2, 2), 'xx');
      vText := substr(vText, 1, vPos1 - 1) || chr(vTmp) || substr(vText, vPos1 + 4, length(vText) - vPos1 - 3);
      vPos2 := vPos1 + 1;
      continue;
    end if;
    -- Skip \anything sequence
    vPos2 := instr(vText, '\', vPos1 + 1); -- The next \
    vPos3 := instr(vText, ' ', vPos1 + 1); -- The next ' '
    vPos4 := instr(vText, chr(13), vPos1 + 1); -- The next Enter
    if vPos4 > 0 and vPos4 < vPos3 then
      vPos3 := vPos4;
    end if;
    if vPos2 = 0 and vPos3 = 0 then
      vPos3 := length(vText);
    end if;
    if vPos2 > 0 and (vPos2 < vPos3 or vPos3 = 0) then
      vText := substr(vText, 1, vPos1 - 1) || substr(vText, vPos2, length(vText) - vPos2 + 1);
      vPos2 := vPos1;
    end if;
    if vPos3 > 0 and (vPos3 < vPos2 or vPos2 = 0) then
      vText := substr(vText, 1, vPos1 - 1) || substr(vText, vPos3 + 1, length(vText) - vPos3);
      vPos2 := vPos1;
    end if;
  end loop;

  return vText;

end;
/
