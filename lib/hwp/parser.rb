# coding: utf-8
#
# parser.rb
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

require 'hwp/tags.rb'

module HWP
    class Context
        attr_reader   :tag_id, :level, :data
        attr_accessor :stack

        def initialize stream
            @stream = stream
            @stack = []
        end

        def has_next?
            not @stream.eof?
        end

        def record_header_decode
            header  = (@stream.read 4).unpack("V")[0]
            @tag_id =  header & 0x3ff
            @level  = (header >> 10) & 0x3ff
            size    = (header >> 20) & 0xfff
            @data = @stream.read size
        end

        def pull
            record_header_decode
        end
    end # Context

    module Parser
        class BodyText
            attr_accessor :paragraphs

            def initialize
                @paragraphs = []
            end # initialize

            # <BodyText> ::= <Section>+
            # <Section> ::= <ParaHeader>+
            # 여기서는 <BodyText> ::= <ParaHeader>+ 로 간주함.
            def parse(context)
                while context.has_next?
                    # stack 이 차 있으면 자식으로부터 제어를 넘겨받은 것이다.
                    context.stack.empty? ? context.pull : context.stack.pop

                    if context.tag_id == HWPTAG::PARA_HEADER and context.level == 0
                        @paragraphs << Record::Section::ParaHeader.new(context)
                    else
                        # FIXME UNKNOWN_TAG 때문에...
                        @paragraphs << Record::Section::ParaHeader.new(context)
                        # FIXME 최상위 태그가 HWPTAG::PARA_HEADER 가 아닐 수도 있다.
                        puts "최상위 태그가 HWPTAG::PARA_HEADER 이 아닌 것 같음"
                        # FIXME UNKNOWN_TAG 때문에.......
                        #raise "unhandled: #{context.tag_id}"
                    end
                end
            end

            def to_text
                # FIXME yield 로 속도 저하 줄일 것.
                text = ""
                @paragraphs.each do |para_header|
                    text << para_header.to_text + "\n"
                end
                text
            end
        end # BodyText

        class ViewText
            def initialize
                raise NotImplementedError.new("ViewText is not supported")
            end
        end

        class SummaryInformation
            def initialize file
            end
        end

        class BinData
            def initialize(stream)
            end
        end

        class PrvText
            def initialize(dirent)
                @dirent = dirent
            end

            def to_s
                @dirent.read.unpack("v*").pack("U*")
            end
        end

        class PrvImage
            def initialize(dirent)
                @dirent = dirent
            end

            def parse
                @dirent.read
            end
        end

        class DocOptions
            def initialize dirent
            end
        end

        class Scripts
            def initialize dirent
            end
        end

        class XMLTemplate
        end

        class DocHistory
            def initialize(dirent)
            end
        end
    end
end
