# coding: utf-8
#
# file_header.rb
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

module HWP
    class FileHeader
        attr_reader :signature, :version
        def initialize file
            @signature	= file.read 32
            @version	= file.read(4).reverse.unpack("C*").join(".")
            @property	= file.read(4).unpack("V")[0]
            @reversed	= file.read 216
        end

        def bit?(n)
            if (@property & (1 <<  n)) == 1
                true
            else
                false
            end
        end
        private :bit?

        def compress?;            bit?(0);  end
        def encrypt?;             bit?(1);  end
        def distribute?;          bit?(2);  end
        def script?;              bit?(3);  end
        def drm?;                 bit?(4);  end
        def xml_template?;        bit?(5);  end
        def history?;             bit?(6);  end
        def sign?;                bit?(7);  end
        def certificate_encrypt?; bit?(8);  end
        def sign_spare?;          bit?(9);  end
        def certificate_drm?;     bit?(10); end
        def ccl?;                 bit?(11); end
    end
end
