# coding: utf-8
#
# document.rb
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

begin
    require 'ole/storage'
rescue LoadError
    puts "If you are a debian user, " +
         "apt-get install libole-ruby or gem install ruby-ole"
    exit
rescue Exception => e
    puts e.message
    puts e.backtrace
    exit
end

require 'hwp/file_header.rb'
require 'hwp/doc_info.rb'
require 'hwp/body_text.rb'
#require 'hwp/view_text.rb'
#require 'hwp/summary_information.rb'
#require 'hwp/bin_data.rb'
#require 'hwp/prv_text.rb'
#require 'hwp/prv_image.rb'
#require 'hwp/doc_options.rb'
#require 'hwp/scripts.rb'
#require 'hwp/xml_template.rb'
#require 'hwp/doc_history.rb'
require 'hwp/model.rb'
require 'hwp/tags.rb'
require 'hwp/parser.rb'
require 'pango'

class Pango::Layout
    def size_in_points
        self.size.collect { |v| v / Pango::SCALE }
    end

    def width_in_points
        self.size[0] / Pango::SCALE
    end

    def height_in_points
        self.size[1] / Pango::SCALE
    end

    def width_in_points=(width)
        self.width = width * Pango::SCALE
    end
end


module HWP
    class File
        attr_reader :header, :doc
        def initialize filename
            ole = Ole::Storage.open(filename, 'rb')
            remain = ole.dir.entries('/') - ['.', '..']
            # 스펙이 명확하지 않고, 추후 스펙이 변할 수 있기 때문에
            # 이를 감지하고자 코드를 이렇게 작성하였다.
            root_entries = [ "FileHeader", "DocInfo", "BodyText", "ViewText",
                        "\005HwpSummaryInformation", "BinData", "PrvText", "PrvImage",
                        "DocOptions", "Scripts", "XMLTemplate", "DocHistory" ]

            @doc = Document.new

            root_entries.each do |entry|
                case ole.file.file? entry
                when true  # file
                    file = ole.file.open entry
                when false # dir
                    dirent = ole.dirent_from_path entry
                when nil   # nothing
                    next
                end

                case entry
                when "FileHeader"
                    @header = FileHeader.new file
                when "DocInfo"
                    if header.compress?
                        # TODO handling by stream
                        z = Zlib::Inflate.new(-Zlib::MAX_WBITS)
                        s_io = StringIO.new(z.inflate file.read)
                        z.finish
                        z.close
                    else
                        s_io = StringIO.new(file.read)
                    end
                    @doc.info = Record::DocInfo.new(s_io)
                    s_io.close
                when "BodyText"
                    body_text = HWP::Parser::BodyText.new
                    dirent.each_child do |section|
                        # TODO handling by stream
                        if header.compress?
                            z = Zlib::Inflate.new(-Zlib::MAX_WBITS)
                            s_io = StringIO.new(z.inflate section.read)
                            z.finish
                            z.close
                        else
                            s_io = StringIO.new(section.read)
                        end
                        context = HWP::Context.new(s_io)
                        body_text.parse(context)
                        s_io.close
                    end
                    @doc.body_text = body_text
                when "ViewText"
                    view_text = HWP::Parser::BodyText.new
                    dirent.each_child do |section|
                        if header.compress?
                            z = Zlib::Inflate.new(-Zlib::MAX_WBITS)
                            s_io = StringIO.new(z.inflate section.read)
                            z.finish
                            z.close
                        else
                            s_io = StringIO.new(section.read)
                        end
                        context = HWP::Context.new(s_io)
                        view_text.parse(context)
                        s_io.close
                    end
                    @doc.view_text = view_text
                when "\005HwpSummaryInformation"
                    @doc.summary_info = HWP::Parser::SummaryInformation.new file
                when "BinData"
                    if header.compress?
                        # TODO handling by stream
                        z = Zlib::Inflate.new(-Zlib::MAX_WBITS)
                        s_io = StringIO.new(z.inflate file.read)
                        z.finish
                        z.close
                    else
                        s_io = StringIO.new(file.read)
                    end
                    @doc.bin_data = Record::BinData.new(s_io)
                    s_io.close
                when "PrvText"
                    @doc.prv_text = HWP::Parser::PrvText.new file
                when "PrvImage"
                    @doc.prv_image = HWP::Parser::PrvImage.new file
                when "DocOptions"
                    @doc.options = HWP::Parser::DocOptions.new dirent
                when "Scripts"
                    @doc.scripts = HWP::Parser::Scripts.new dirent
                when "XMLTemplate"
                    @doc.xml_template = Record::XMLTemplate.new dirent
                when "DocHistory"
                    @doc.history = Record::DocHistory.new(dirent)
                else raise "unknown entry"
                end
                # 스펙에 앖는 것을 감지하기 위한 코드
                remain = remain - [entry]
            end # root_entries.each

            ole.close
            raise "unknown entry" unless remain.empty?
        end
    end

    class Document
        attr_accessor :info, :body_text, :view_text, :summary_info, :bin_data,
                      :prv_text, :prv_image, :options, :scripts, :xml_template,
                      :history

        # 아래는 렌더링에 관련된 함수이다.
        def get_page n
            if @pages.nil?
                make_pages()
            end
            @pages[n]
        end

        def n_pages
            if @pages.nil?
                make_pages()
            end
            @n_pages
        end

        def make_pages
            layouts = []
            @body_text.paragraphs.each do |para|
                layouts << para.to_layout(self)
            end

            @pages = []
            @n_pages = 0

            section_def = @body_text.paragraphs[0].ctrl_headers[0].section_defs[0]
            page_def = section_def.page_defs[0]

            @y = (page_def.top_margin + page_def.header_margin) / 100.0

            layouts.each do |layout|
                @y = @y + layout.pixel_size[1]
                if @y > (page_def.height - page_def.bottom_margin - page_def.footer_margin) / 100.0
                    @n_pages += 1
                    @y = (page_def.top_margin + page_def.header_margin) / 100.0
                end
                @pages[@n_pages] ||= Page.new(page_def.width / 100.0, page_def.height / 100.0)
                @pages[@n_pages].layouts << layout
            end
        end
    end # Document

    class Page
        attr_accessor :layouts
        def initialize(width=nil, height=nil)
            @width, @height = width, height
            @layouts = []
        end

        def size
            [@width, @height]
        end
    end
end # HWP
