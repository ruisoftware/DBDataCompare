{*** rs.inc include file
 * This file is included into each component unit and serves
 * as a common place to specify compiler directives and conditional defines.
 *
 * 2002 by Jose Rui Santos
 * http://www.RuiSoftware.com
 * mailto:Delphi@RuiSoftware.com
 * License: Freeware
 *}
{$IFDEF WIN32}
  {$DEFINE DELPHI2_OR_HIGHER}
{$ENDIF}

{$IFNDEF VER80}
  {$IFNDEF VER90}
    {$IFNDEF VER93}
      {$DEFINE DELPHI3_OR_HIGHER}
      {$IFNDEF VER100}
        {$DEFINE BCB3_OR_HIGHER}
        {$IFNDEF VER110}
          {$DEFINE DELPHI4_OR_HIGHER}
          {$IFNDEF VER120}
            {$DEFINE BCB4_OR_HIGHER}
            {$IFNDEF VER125}
              {$DEFINE DELPHI5_OR_HIGHER}
              {$IFNDEF VER140}
                {$DEFINE DELPHI6_OR_HIGHER}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER93}
  {$DEFINE BCB_COMPILER}
{$ENDIF}
{$IFDEF VER110}
  {$DEFINE BCB_COMPILER}
  {$OBJEXPORTALL ON}
{$ENDIF}
{$IFDEF VER125}
  {$DEFINE BCB_COMPILER}
  {$OBJEXPORTALL ON}
{$ENDIF}

{ Code Generation Directives }
{$F-}   { Force Far Calls}
{$A+}   { Word Align Data }
{$U-}   { Pentium-Safe FDIV}
{$K-}   { Smart CallBacks }
{$W-}   { Windows Stack Frame }
{$O+}   { Optimization }

{ Runtime Erros }
{$IFOPT D+}
  {$R+} { Range Checking On - if compiled with Debug Information }
{$ELSE}
  {$R-} { Range Checking Off - if compiled with Debug Information }
{$ENDIF}

{$S-}   { Stack Checking }
{$I+}   { I/O Checking }
{$Q-}   { Overflow Checking }


{ Syntax Options }

{$V-}   { Strict Var-Strings }
{$B-}   { Complete Boolean Evaluator }
{$X+}   { Extented Syntax }
{$T-}   { Typed @ Operator }
{$P+}   { Open Parameters }
{$IFDEF DELPHI4_OR_HIGHER}
{$J+}   { Writeable Typed Constants }
{$ENDIF}

{ Miscellaneous Directives }

{$C MOVEABLE DEMANDLOAD DISCARDABLE}      { Code Segment Attribute }
{$G+}   { Delphi 1: 286 Instructions / Delphi 3 & later: Imported Data }
{$N+}   { Numeric Coprocessor }
{$Z-}   { Word Size Enumerated Types }

{$IFDEF WIN32}
{$H+}   { Long String Support }
{$ENDIF}

