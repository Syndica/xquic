const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const xquic = b.addStaticLibrary(.{
        .name = "xquic",
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(xquic);

    const translate_c = b.addTranslateC(.{
        .root_source_file = b.path("include/xquic/xquic.h"),
        .target = target,
        .optimize = optimize,
    });
    const mod = b.addModule("xquic", .{
        .root_source_file = translate_c.getOutput(),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });
    mod.linkLibrary(xquic);

    const boringssl = b.dependency("boringssl", .{
        .target = target,
        .optimize = optimize,
    });

    xquic.addIncludePath(b.path("include"));
    xquic.addIncludePath(b.path("."));
    xquic.addIncludePath(boringssl.path("vendor/include"));

    xquic.addCSourceFiles(.{
        .files = &.{
            "src/transport/xqc_engine.c",
            "src/transport/xqc_conn.c",
            "src/transport/xqc_client.c",
            "src/transport/xqc_cid.c",
            "src/transport/xqc_packet_parser.c",
            "src/transport/xqc_frame_parser.c",
            "src/transport/xqc_stream.c",
            "src/transport/xqc_datagram.c",
            "src/transport/xqc_packet_out.c",
            "src/transport/xqc_packet_in.c",
            "src/transport/xqc_send_ctl.c",
            "src/transport/xqc_send_queue.c",
            "src/transport/xqc_packet.c",
            "src/transport/xqc_frame.c",
            "src/transport/xqc_recv_record.c",
            "src/transport/xqc_pacing.c",
            "src/transport/xqc_utils.c",
            "src/transport/xqc_multipath.c",
            "src/transport/xqc_defs.c",
            "src/transport/xqc_transport_params.c",
            "src/transport/xqc_quic_lb.c",
            "src/transport/xqc_timer.c",
            "src/transport/xqc_reinjection.c",
            "src/transport/reinjection_control/xqc_reinj_default.c",
            "src/transport/reinjection_control/xqc_reinj_deadline.c",
            "src/transport/reinjection_control/xqc_reinj_dgram.c",
            "src/transport/scheduler/xqc_scheduler_minrtt.c",
            "src/transport/scheduler/xqc_scheduler_common.c",
            "src/transport/scheduler/xqc_scheduler_backup.c",
            "src/transport/scheduler/xqc_scheduler_rap.c",
            "src/common/xqc_random.c",
            "src/common/xqc_str.c",
            "src/common/xqc_log.c",
            "src/common/xqc_log_event_callback.c",
            "src/common/xqc_time.c",
            "src/common/utils/huffman/xqc_huffman_code.c",
            "src/common/utils/huffman/xqc_huffman.c",
            "src/common/utils/vint/xqc_discrete_int_parser.c",
            "src/common/utils/vint/xqc_variable_len_int.c",
            "src/common/utils/ringarray/xqc_ring_array.c",
            "src/common/utils/ringmem/xqc_ring_mem.c",
            "src/common/utils/2d_hash/xqc_2d_hash_table.c",
            "src/common/utils/var_buf/xqc_var_buf.c",
        },
    });
}
