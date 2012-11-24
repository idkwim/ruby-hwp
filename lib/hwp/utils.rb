# coding: utf-8
#
# utils.rb
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

module HWP
    module Utils
        def hierarchy_check(level1, level2, line_num)
            if level1 != level2 - 1
                p [level1, level2]
                raise "hierarchy error at line #{line_num}"
            end
        end
    end # Utils
end # HWP

class String
    def to_formatted_hex
        self.bytes.to_a.map{|c| sprintf("%02x", c)}.join(" ")
    end
end
