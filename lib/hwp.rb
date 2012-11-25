# coding: utf-8
#
# hwp.rb
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

require 'hwp/version.rb'
require 'hwp/document.rb'

module HWP
    def self.open filename
        hwpfile = HWP::HWPFile.new filename
        hwpfile.doc
    end
end
