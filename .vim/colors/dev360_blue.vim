" Vim color file - dev360_blue a tweaked version of maroloccio
" Generated by http://bytefluent.com/vivify 2013-02-13
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "dev360_blue"

hi IncSearch guifg=#0e1219 guibg=#2680af guisp=#2680af gui=NONE ctermfg=234 ctermbg=25 cterm=NONE
hi WildMenu guifg=#8b9aaa guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=103 ctermbg=234 cterm=NONE
"hi SignColumn -- no settings --
hi SpecialComment guifg=#6d5279 guibg=NONE guisp=NONE gui=NONE ctermfg=96 ctermbg=NONE cterm=NONE
hi Typedef guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi Title -- no settings --
hi Folded guifg=#8b9aaa guibg=#2c3138 guisp=#2c3138 gui=NONE ctermfg=103 ctermbg=237 cterm=NONE
hi PreCondit guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Include guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi TabLineSel -- no settings --
hi StatusLineNC guifg=#2c3138 guibg=#8b9aaa guisp=#8b9aaa gui=NONE ctermfg=237 ctermbg=103 cterm=NONE
"hi CTagsMember -- no settings --
hi NonText guifg=#2c3138 guibg=NONE guisp=NONE gui=NONE ctermfg=237 ctermbg=NONE cterm=NONE
"hi CTagsGlobalConstant -- no settings --
"hi DiffText -- no settings --
"hi ErrorMsg -- no settings --
"hi Ignore -- no settings --
hi Debug guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=NONE guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=NONE ctermbg=234 cterm=NONE
"hi Identifier -- no settings --
hi SpecialChar guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Conditional guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi StorageClass guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Todo guifg=#82ade0 guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=110 ctermbg=234 cterm=NONE
hi Special guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi LineNr guifg=#2c3138 guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=237 ctermbg=234 cterm=NONE
hi StatusLine guifg=#8b9aaa guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=103 ctermbg=234 cterm=NONE
hi Normal guifg=#8b9aaa guibg=#1a202a guisp=#1a202a gui=NONE ctermfg=103 ctermbg=235 cterm=NONE
hi Label guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi CTagsImport -- no settings --
hi PMenuSel guifg=#0e1219 guibg=#8b9aaa guisp=#8b9aaa gui=NONE ctermfg=234 ctermbg=103 cterm=NONE
hi Search guifg=#0e1219 guibg=#82ade0 guisp=#82ade0 gui=NONE ctermfg=234 ctermbg=110 cterm=NONE
"hi CTagsGlobalVariable -- no settings --
hi Delimiter guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Statement guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
hi Comment guifg=#6d5279 guibg=NONE guisp=NONE gui=NONE ctermfg=96 ctermbg=NONE cterm=NONE
hi Character guifg=#82ade0 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi Float guifg=#82ade0 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi Number guifg=#82ade0 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi Boolean guifg=#82ade0 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi Operator guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi CursorLine guifg=NONE guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=NONE ctermbg=234 cterm=NONE
"hi Union -- no settings --
"hi TabLineFill -- no settings --
"hi Question -- no settings --
"hi WarningMsg -- no settings --
"hi VisualNOS -- no settings --
"hi DiffDelete -- no settings --
"hi ModeMsg -- no settings --
hi CursorColumn guifg=NONE guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=NONE ctermbg=234 cterm=NONE
hi Define guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Function guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi FoldColumn -- no settings --
hi PreProc guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi EnumerationName -- no settings --
hi Visual guifg=#0e1219 guibg=#6d5279 guisp=#6d5279 gui=NONE ctermfg=234 ctermbg=96 cterm=NONE
"hi MoreMsg -- no settings --
"hi SpellCap -- no settings --
hi VertSplit guifg=#2c3138 guibg=#8b9aaa guisp=#8b9aaa gui=NONE ctermfg=237 ctermbg=103 cterm=NONE
hi Exception guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Keyword guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Type guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi DiffChange -- no settings --
hi Cursor guifg=#0e1219 guibg=#8b9aaa guisp=#8b9aaa gui=NONE ctermfg=234 ctermbg=103 cterm=NONE
"hi SpellLocal -- no settings --
hi Error guifg=#8b9aaa guibg=#8f3231 guisp=#8f3231 gui=NONE ctermfg=103 ctermbg=88 cterm=NONE
hi PMenu guifg=#8b9aaa guibg=#2c3138 guisp=#2c3138 gui=NONE ctermfg=103 ctermbg=237 cterm=NONE
hi SpecialKey guifg=#2c3138 guibg=NONE guisp=NONE gui=NONE ctermfg=237 ctermbg=NONE cterm=NONE
hi Constant guifg=#82ade0 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
"hi DefinedName -- no settings --
hi Tag guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi String guifg=#82ade0 guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#2c3138 guisp=#2c3138 gui=NONE ctermfg=NONE ctermbg=237 cterm=NONE
"hi MatchParen -- no settings --
"hi LocalVariable -- no settings --
hi Repeat guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
"hi Directory -- no settings --
hi Structure guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Macro guifg=#2680af guibg=NONE guisp=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE
hi Underlined guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
"hi DiffAdd -- no settings --
hi TabLine guifg=#8b9aaa guibg=#0e1219 guisp=#0e1219 gui=NONE ctermfg=103 ctermbg=234 cterm=NONE
hi mbenormal guifg=#533434 guibg=#3f283f guisp=#3f283f gui=NONE ctermfg=239 ctermbg=237 cterm=NONE
hi perlspecialstring guifg=#531e53 guibg=#403940 guisp=#403940 gui=NONE ctermfg=53 ctermbg=238 cterm=NONE
hi doxygenspecial guifg=#81531e guibg=NONE guisp=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
hi mbechanged guifg=#5c5072 guibg=#3f283f guisp=#3f283f gui=NONE ctermfg=60 ctermbg=237 cterm=NONE
hi mbevisiblechanged guifg=#5c5072 guibg=#2f2f8f guisp=#2f2f8f gui=NONE ctermfg=60 ctermbg=18 cterm=NONE
hi doxygenparam guifg=#81531e guibg=NONE guisp=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
hi doxygensmallspecial guifg=#81531e guibg=NONE guisp=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
hi doxygenprev guifg=#81531e guibg=NONE guisp=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
hi perlspecialmatch guifg=#531e53 guibg=#403940 guisp=#403940 gui=NONE ctermfg=53 ctermbg=238 cterm=NONE
hi cformat guifg=#531e53 guibg=#403940 guisp=#403940 gui=NONE ctermfg=53 ctermbg=238 cterm=NONE
hi lcursor guifg=#342934 guibg=#77ff2d guisp=#77ff2d gui=NONE ctermfg=236 ctermbg=82 cterm=NONE
hi cursorim guifg=#f8f8f8 guibg=#8000ff guisp=#8000ff gui=NONE ctermfg=15 ctermbg=93 cterm=NONE
hi doxygenspecialmultilinedesc guifg=#342934 guibg=NONE guisp=NONE gui=NONE ctermfg=236 ctermbg=NONE cterm=NONE
hi taglisttagname guifg=#1a2f6e guibg=NONE guisp=NONE gui=NONE ctermfg=17 ctermbg=NONE cterm=NONE
hi doxygenbrief guifg=#814908 guibg=NONE guisp=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
hi mbevisiblenormal guifg=#534153 guibg=#2f2f8f guisp=#2f2f8f gui=NONE ctermfg=239 ctermbg=18 cterm=NONE
hi user2 guifg=#342934 guibg=#22385e guisp=#22385e gui=NONE ctermfg=236 ctermbg=17 cterm=NONE
hi user1 guifg=#57826e guibg=#22385e guisp=#22385e gui=NONE ctermfg=66 ctermbg=17 cterm=NONE
hi doxygenspecialonelinedesc guifg=#342934 guibg=NONE guisp=NONE gui=NONE ctermfg=236 ctermbg=NONE cterm=NONE
hi doxygencomment guifg=#342934 guibg=NONE guisp=NONE gui=NONE ctermfg=236 ctermbg=NONE cterm=NONE
hi cspecialcharacter guifg=#531e53 guibg=#403940 guisp=#403940 gui=NONE ctermfg=53 ctermbg=238 cterm=NONE
"hi clear -- no settings --
hi menu guifg=#342934 guibg=#dbffa1 guisp=#dbffa1 gui=NONE ctermfg=236 ctermbg=193 cterm=NONE
hi scrollbar guifg=#342934 guibg=#dbffa1 guisp=#dbffa1 gui=bold ctermfg=236 ctermbg=193 cterm=bold
hi _coperators guifg=#6e5782 guibg=NONE guisp=NONE gui=NONE ctermfg=96 ctermbg=NONE cterm=NONE
hi xmltag guifg=#7d577d guibg=NONE guisp=NONE gui=NONE ctermfg=96 ctermbg=NONE cterm=NONE
hi xmlattrib guifg=#342934 guibg=NONE guisp=NONE gui=NONE ctermfg=236 ctermbg=NONE cterm=NONE
hi xmltagname guifg=#7d577d guibg=NONE guisp=NONE gui=NONE ctermfg=96 ctermbg=NONE cterm=NONE
hi xmlcomment guifg=#342934 guibg=NONE guisp=NONE gui=NONE ctermfg=236 ctermbg=NONE cterm=NONE
hi xmlentity guifg=#342934 guibg=NONE guisp=NONE gui=NONE ctermfg=236 ctermbg=NONE cterm=NONE
hi xmlendtag guifg=#7d577d guibg=NONE guisp=NONE gui=NONE ctermfg=96 ctermbg=NONE cterm=NONE
"hi htmlitalic -- no settings --
"hi htmlboldunderlineitalic -- no settings --
"hi htmlbolditalic -- no settings --
"hi htmlunderlineitalic -- no settings --
"hi htmlbold -- no settings --
"hi htmlboldunderline -- no settings --
"hi htmlunderline -- no settings --
hi htmllink guifg=#0000ff guibg=NONE guisp=NONE gui=NONE ctermfg=21 ctermbg=NONE cterm=NONE
