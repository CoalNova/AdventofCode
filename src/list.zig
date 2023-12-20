const prc = @import("process.zig");

pub fn proc(p: prc.Proc) void {
    switch (p.year) {
        2023 => { 
            switch (p.day) {
                1 => @import("2023/01.zig").Day.proc(p),
                2 => @import("2023/02.zig").Day.proc(p),
                3 => @import("2023/03.zig").Day.proc(p),
                4 => @import("2023/04.zig").Day.proc(p),
                5 => @import("2023/05.zig").Day.proc(p),
                6 => @import("2023/06.zig").Day.proc(p),
                7 => @import("2023/07.zig").Day.proc(p),
                8 => @import("2023/08.zig").Day.proc(p),
                9 => @import("2023/09.zig").Day.proc(p),
                else => {},
            }
        },
        else => {},
    }
}
