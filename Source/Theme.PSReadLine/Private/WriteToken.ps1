function WriteToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.Token]
        $Token,

        [Parameter(Mandatory)]
        [Text.StringBuilder]
        $StringBuilder,

        $Theme
    )
    $null = switch ($token) {
        { $_ -is [StringExpandableToken] } {
            $startingOffset = $_.Extent.StartOffset
            $lastEndOffset = $startingOffset
            foreach ($nestedToken in $_.NestedTokens) {
                $StringBuilder.Append($Theme.StringColor)
                $StringBuilder.Append($_.Text, $lastEndOffset - $startingOffset, $nestedToken.Extent.StartOffset - $lastEndOffset)

                WriteToken -Token $nestedToken -StringBuilder $StringBuilder -Theme $Theme
                $lastEndOffset = $nestedToken.Extent.EndOffset
            }
            $StringBuilder.Append($Theme.StringColor)
            $StringBuilder.Append($_.Text, $lastEndOffset - $startingOffset, $_.Extent.EndOffset - $lastEndOffset)
            return
        }
        { $_ -is [StringToken] } {
            if ($_.TokenFlags.HasFlag([TokenFlags]::CommandName)) {
                $StringBuilder.Append($Theme.CommandColor)
                break
            }
            $StringBuilder.Append($Theme.StringColor)
            break
        }
        { $_ -is [NumberToken] } { $StringBuilder.Append($Theme.NumberColor); break }
        { $_ -is [ParameterToken] } { $StringBuilder.Append($Theme.ParameterColor); break }
        { $_ -is [VariableToken] } { $StringBuilder.Append($Theme.VariableColor); break }
        { $_.TokenFlags.HasFlag([TokenFlags]::BinaryOperator) } { $StringBuilder.Append($Theme.OperatorColor); break }
        { $_.TokenFlags.HasFlag([TokenFlags]::UnaryOperator) } { $StringBuilder.Append($Theme.OperatorColor); break }
        { $_.TokenFlags.HasFlag([TokenFlags]::CommandName) } { $StringBuilder.Append($Theme.CommandColor); break; }
        { $_.TokenFlags.HasFlag([TokenFlags]::MemberName) } { $StringBuilder.Append($Theme.MemberColor); break; }
        { $_.TokenFlags.HasFlag([TokenFlags]::TypeName) } { $StringBuilder.Append($Theme.TypeColor); break; }
        { $_.TokenFlags.HasFlag([TokenFlags]::Keyword) } { $StringBuilder.Append($Theme.KeywordColor); break; }
        { $_ -is [StringToken] } { $StringBuilder.Append($Theme.StringColor); break }
        default { $StringBuilder.Append($Theme.DefaultTokenColor); break }
    }
    $null = $StringBuilder.Append($token.Text)
}
