local words = {}

function words.reverse_string(str)
	local buff = {}
	for i = #str, 1, -1 do
		table.insert(buff, string.sub(str, i, i))
	end
	return table.concat(buff, "")
end

function words.is_palindrome(str)
	local cleaned_str = string.gsub(str, "%s+", "")
	local i = 1
	local j = #cleaned_str
	while i < j do
		if string.sub(cleaned_str, i, i) ~= string.sub(cleaned_str, j, j) then
			return false
		end
		i = i + 1
		j = j - 1
	end
	return true
end

function compute_lps_array(patt)
	local len_patt = #patt
	local lps = {}
	lps[0] = 0
	local i = 2
	local len = 0
	while i < len_patt do
		if string.sub(patt, i, i) == string.sub(patt, len + 1, len + 1) then
			len = len + 1
			lps[i - 1] = len
			i = i + 1
		else
			if len > 0 then
				len = lps[len - 1]
			else
				lps[i - 1] = 0
				i = i + 1
			end
		end
	end
	return lps
end

function words.kmp_search(pat, txt)
	local len_pat = #pat
	local len_txt = #txt
	if len_pat == 0 then
		return true
	elseif len_pat > len_txt then
		return false
	end
	local lps = compute_lps_array(pat)
	local i = 1
	local j = 1
	while i <= len_txt do
		if string.sub(txt, i, i) == string.sub(pat, j, j) then
			i = i + 1
			j = j + 1
			if j > len_pat then
				return true
			end
		else
			if j > 1 then
				j = lps[j - 1]
				if j == 0 then
					j = 1
				end
			else
				i = i + 1
			end
		end
	end
	return false
end

function create_matrix(rows, cols)
    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = 0
        end
    end
    return matrix
end

function print_matrix(matrix)
    for i, row in ipairs(matrix) do
        local row_str = ""
        for j, value in ipairs(row) do
            row_str = row_str .. tostring(value) .. "\t"
        end
        print(row_str)
    end
end

function words.lcs(str1, str2)
	local len1 = #str1
	local len2 = #str2
	local dp = create_matrix(len1 + 1, len2 + 1)
	for i = 2, len1+1 do
		for j = 2, len2+1 do
			local i_ = i - 1
			local j_ = j - 1
			if string.sub(str1, i_, i_) == string.sub(str2, j_, j_) then
				dp[i][j] = dp[i - 1][j - 1] + 1
			else
				dp[i][j] = math.max(dp[i - 1][j], dp[i][j - 1])
			end
		end
	end
	return dp[len1+1][len2+1]
end
return words