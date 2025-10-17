const std = @import("std");

pub fn reverse_string(str: []const u8) []const u8 {
    const len: usize = str.len;
    var buffer = std.heap.page_allocator.alloc(u8, len) catch {
        return &.{};
    };
    for (str, 0..) |byte, index| {
        buffer[len - index - 1] = byte;
    }
    return buffer;
}

fn removeWhitespaces(str: []const u8, allocator: *const std.mem.Allocator) ![]u8 {
    var buffer = try allocator.alloc(u8, str.len);

    var index: usize = 0;
    for (str) |char| {
        if (!std.ascii.isWhitespace(char)) {
            buffer[index] = char;
            index += 1;
        }
    }
    // Shrink the allocated memory to the exact size of the content.
    // This ensures that what we free later has the same size as what we allocated.
    return allocator.realloc(buffer, index);
}

pub fn is_palindrome(str: []const u8) !bool {
    if (str.len <= 1) {
        return true;
    }
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = &gpa.allocator();
    const cleannedStr = try removeWhitespaces(str, allocator);
    defer allocator.free(cleannedStr);

    var i: usize = 0;
    var j: usize = cleannedStr.len - 1;
    while (i < j) {
        if (cleannedStr[i] != cleannedStr[j]) {
            return false;
        }
        i += 1;
        j -= 1;
    }
    return true;
}

fn computeLpsArray(pattern: []const u8, allocator: *const std.mem.Allocator) ![]usize {
    const len_pattern: usize = pattern.len;
    var lps = try allocator.alloc(usize, len_pattern);
    lps[0] = 0;
    var i: usize = 1;
    var len: usize = 0;
    while (i < len_pattern) {
        if (pattern[i] == pattern[len]) {
            len += 1;
            lps[i] = len;
            i += 1;
        } else {
            if (len > 0) {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i += 1;
            }
        }
    }
    return lps;
}

pub fn kmp_search(sub: []const u8, str: []const u8) !bool {
    const len_sub: usize = sub.len;
    const len_str: usize = str.len;
    if (len_sub == 0) {
        return true;
    } else if (len_sub > len_str) {
        return false;
    }
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = &gpa.allocator();
    const lps = try computeLpsArray(sub, allocator);
    defer allocator.free(lps);
    var i: usize = 0;
    var j: usize = 0;
    while (i < len_str) {
        if (str[i] == sub[j]) {
            i += 1;
            j += 1;
            if (j == len_sub) {
                return true;
            }
        } else {
            if (j > 0) {
                j = lps[j - 1];
            } else {
                i += 1;
            }
        }
    }
    return false;
}

pub fn lcs(str1: []const u8, str2: []const u8) !usize {
    const len1: usize = str1.len;
    const len2: usize = str2.len;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = &gpa.allocator();

    var dp = try allocator.alloc(usize, (len1 + 1) * (len2 + 1));
    defer allocator.free(dp);

    for (0..(len1 + 1)) |i| {
        for (0..(len2 + 1)) |j| {
            dp[i * (len2 + 1) + j] = 0;
        }
    }

    for (1..(len1 + 1)) |i| {
        for (1..(len2 + 1)) |j| {
            if (str1[i - 1] == str2[j - 1]) {
                dp[i * (len2 + 1) + j] = dp[(i - 1) * (len2 + 1) + j - 1] + 1;
            } else {
                dp[i * (len2 + 1) + j] = @max(dp[(i - 1) * (len2 + 1) + j], dp[i * (len2 + 1) + j - 1]);
            }
        }
    }
    return dp[len1 * (len2 + 1) + len2];
}
