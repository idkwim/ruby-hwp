#!/usr/bin/ruby1.9.1
# coding: utf-8
# 한글과컴퓨터의 글 문서 파일(.hwp) 공개 문서를 참고하여
# 개발하였습니다.

begin
    require 'hwp'
rescue Exception
    $LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + '/lib'
    require 'hwp'
end

if ARGV[0]
    doc = HWP.open ARGV[0]
else
    doc = HWP.open(File.expand_path(File.dirname(__FILE__)) +
        "/samples/kreg1.hwp")
end

require 'pp'

pp doc.info
# doc.info.char_shapes.length
# doc.info.char_shapes.each { |shape| p shape }
#p @doc.info.char_shapes[0].lang[:korean].font_id
#p @doc.info.char_shapes[0].lang[:korean].ratio
#p @doc.info.char_shapes[0].lang[:korean].char_spacing
#p @doc.info.char_shapes[0].lang[:korean].rel_size
#p @doc.info.char_shapes[0].lang[:korean].char_offset

# doc.info.document_properties
# doc.info.id_mappings
# p doc.info.bin_data
# p doc.info.bin_data[0].type
# p doc.info.bin_data[0].id
# p doc.info.bin_data[0].format
# p doc.info.bin_data[0].compress_policy
# p doc.info.bin_data[0].status
# p doc.info.face_names
# p doc.info.face_names[0].font_type_info
# p doc.info.face_names[0].font_type_info.family

#p @doc.body_text
#p @doc.body_text.para_headers
