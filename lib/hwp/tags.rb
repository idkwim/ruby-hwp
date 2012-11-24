# coding: utf-8
#
# tags.rb
#
# Copyright (C) 2010-2012  Hodong Kim <cogniti@gmail.com>
# 
# ruby-hwp is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# ruby-hwp is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# 한글과컴퓨터의 한/글 문서 파일(.hwp) 공개 문서를 참고하여 개발하였습니다.

module HWPTAG
    # 루비 키워드 BEGIN과 충돌을 피하기 위해 상수명 BEGIN_
    BEGIN_               = 16 # 0x10
    # docinfo
    DOCUMENT_PROPERTIES  = 16
    ID_MAPPINGS          = 17
    BIN_DATA             = 18
    FACE_NAME            = 19
    BORDER_FILL          = 20
    CHAR_SHAPE           = 21
    TAB_DEF              = 22
    NUMBERING            = 23
    BULLET               = 24
    PARA_SHAPE           = 25
    STYLE                = 26
    DOC_DATA             = 27
    DISTRIBUTE_DOC_DATA  = 28
    # 상수명 충돌을 피하기 위해 _29
    RESERVED_29          = 29
    COMPATIBLE_DOCUMENT  = 30
    LAYOUT_COMPATIBILITY = 31
    DOC_INFO_32          = 32 # 레이아웃 관련 태그로 추정됨.
    FORBIDDEN_CHAR       = 94
	# section
    PARA_HEADER               =  66
    PARA_TEXT                 =  67
    PARA_CHAR_SHAPE           =  68
    PARA_LINE_SEG             =  69
    PARA_RANGE_TAG            =  70
    CTRL_HEADER               =  71
    LIST_HEADER               =  72
    PAGE_DEF                  =  73
    FOOTNOTE_SHAPE            =  74
    PAGE_BORDER_FILL          =  75
    SHAPE_COMPONENT           =  76
    TABLE                     =  77
    SHAPE_COMPONENT_LINE      =  78
    SHAPE_COMPONENT_RECTANGLE =  79
    SHAPE_COMPONENT_ELLIPSE   =  80
    SHAPE_COMPONENT_ARC       =  81
    SHAPE_COMPONENT_POLYGON   =  82
    SHAPE_COMPONENT_CURVE     =  83
    SHAPE_COMPONENT_OLE       =  84
    SHAPE_COMPONENT_PICTURE   =  85
    SHAPE_COMPONENT_CONTAINER =  86
    CTRL_DATA                 =  87
    EQEDIT                    =  88
    RESERVED_89               =  89
    SHAPE_COMPONENT_TEXTART   =  90
    FORM_OBJECT               =  91
    MEMO_SHAPE                =  92
    MEMO_LIST                 =  93
    CHART_DATA                =  95
    SHAPE_COMPONENT_UNKNOWN   = 115

    # 알려지지 않은 태그인가 ??
    # https://groups.google.com/forum/#!msg/libhwp/fpnsqz5i_W0/ErxIq-OV81MJ
    UNKNOWN_TAG_0   =   0
    UNKNOWN_TAG_1   =   1
    UNKNOWN_TAG_3   =   3
    UNKNOWN_TAG_4   =   4
    UNKNOWN_TAG_58  =  58
    UNKNOWN_TAG_172 = 172
    UNKNOWN_TAG_190 = 190
    UNKNOWN_TAG_199 = 199
    UNKNOWN_TAG_256 = 256
    UNKNOWN_TAG_257 = 257
    UNKNOWN_TAG_288 = 288
    UNKNOWN_TAG_512 = 512
    UNKNOWN_TAG_520 = 520
    UNKNOWN_TAG_560 = 560
    UNKNOWN_TAG_652 = 652
    UNKNOWN_TAG_710 = 710
    UNKNOWN_TAG_888 = 888
end

module HISTORY_RECORD_TYPE
    STAG        = 0x10
    ETAG        = 0x11
    VERSION     = 0x20
    DATE        = 0x21
    WRITER      = 0x22
    DESCRIPTION = 0x23
    DIFFDATA    = 0x30
    LASTDOCDATA = 0x31
end
