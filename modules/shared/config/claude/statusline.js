#!/usr/bin/env node
'use strict';

// Reference:
// https://zenn.dev/pnd/articles/claude-code-statusline

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Constants
const COMPACTION_THRESHOLD = 200000 * 0.8;

// Powerline symbols (U+E0B0 - requires powerline-compatible font)
const PL_RIGHT = '\ue0b0';

// ANSI color helpers (256 color mode)
const fg = (color) => `\x1b[38;5;${color}m`;
const bg = (color) => `\x1b[48;5;${color}m`;
const reset = '\x1b[0m';

// Color palette (256 color codes)
const colors = {
    modelBg: 33,          // Blue
    modelFg: 255,         // White
    dirBg: 240,           // Dark gray
    dirFg: 255,           // White
    tokenBg: 238,         // Darker gray
    tokenFg: 255,         // White
    percentGreenBg: 22,   // Dark green
    percentYellowBg: 136, // Dark yellow/orange
    percentRedBg: 124,    // Dark red
    percentFg: 255,       // White
};

// Build a powerline segment
function segment(text, fgColor, bgColor, nextBgColor) {
    return `${bg(bgColor)}${fg(fgColor)} ${text} ${fg(bgColor)}${bg(nextBgColor)}${PL_RIGHT}`;
}

// Final segment (no next background)
function finalSegment(text, fgColor, bgColor) {
    return `${bg(bgColor)}${fg(fgColor)} ${text} ${reset}${fg(bgColor)}${PL_RIGHT}${reset}`;
}

function formatTokenCount(tokens) {
    if (tokens >= 1000000) {
        return `${(tokens / 1000000).toFixed(1)}M`;
    } else if (tokens >= 1000) {
        return `${(tokens / 1000).toFixed(1)}K`;
    }
    return tokens.toString();
}

function calculateTokensFromTranscript(filePath) {
    return new Promise((resolve) => {
        let lastUsage = null;
        let resolved = false;

        const fileStream = fs.createReadStream(filePath);
        const rl = readline.createInterface({
            input: fileStream,
            crlfDelay: Infinity
        });

        rl.on('line', (line) => {
            try {
                const entry = JSON.parse(line);
                if (entry.type === 'assistant' && entry.message?.usage) {
                    lastUsage = entry.message.usage;
                }
            } catch {
                // Skip invalid JSON lines
            }
        });

        rl.on('close', () => {
            if (resolved) return;
            resolved = true;

            if (lastUsage) {
                const totalTokens = (lastUsage.input_tokens || 0) +
                    (lastUsage.output_tokens || 0) +
                    (lastUsage.cache_creation_input_tokens || 0) +
                    (lastUsage.cache_read_input_tokens || 0);
                resolve(totalTokens);
            } else {
                resolve(0);
            }
        });

        fileStream.on('error', (err) => {
            if (resolved) return;
            resolved = true;
            console.error(`Failed to read transcript: ${err.message}`);
            resolve(0);
        });
    });
}

function findTranscriptFile(sessionId) {
    const projectsDir = path.join(process.env.HOME, '.claude', 'projects');

    if (!fs.existsSync(projectsDir)) {
        return null;
    }

    let projectDirs;
    try {
        projectDirs = fs.readdirSync(projectsDir)
            .map(dir => path.join(projectsDir, dir))
            .filter(dir => {
                try {
                    return fs.statSync(dir).isDirectory();
                } catch {
                    return false;
                }
            });
    } catch {
        return null;
    }

    for (const projectDir of projectDirs) {
        const transcriptFile = path.join(projectDir, `${sessionId}.jsonl`);
        if (fs.existsSync(transcriptFile)) {
            return transcriptFile;
        }
    }

    return null;
}

function buildStatusLine(model, currentDir, tokenDisplay, percentage) {
    let percentBgColor = colors.percentGreenBg;
    if (percentage >= 70) percentBgColor = colors.percentYellowBg;
    if (percentage >= 90) percentBgColor = colors.percentRedBg;

    return segment(model, colors.modelFg, colors.modelBg, colors.dirBg) +
        segment(`📁 ${currentDir}`, colors.dirFg, colors.dirBg, colors.tokenBg) +
        segment(`🪙 ${tokenDisplay}`, colors.tokenFg, colors.tokenBg, percentBgColor) +
        finalSegment(`${percentage}%`, colors.percentFg, percentBgColor);
}

function buildErrorStatusLine() {
    return segment('Error', colors.percentFg, colors.percentRedBg, colors.dirBg) +
        finalSegment('📁 .', colors.dirFg, colors.dirBg);
}

async function main() {
    let input = '';

    for await (const chunk of process.stdin) {
        input += chunk;
    }

    try {
        const data = JSON.parse(input);

        const model = data.model?.display_name || 'Unknown';
        const currentDir = path.basename(data.workspace?.current_dir || data.cwd || '.');
        const sessionId = data.session_id;

        let totalTokens = 0;

        if (sessionId) {
            const transcriptFile = findTranscriptFile(sessionId);
            if (transcriptFile) {
                totalTokens = await calculateTokensFromTranscript(transcriptFile);
            }
        }

        const percentage = Math.min(100, Math.round((totalTokens / COMPACTION_THRESHOLD) * 100));
        const tokenDisplay = formatTokenCount(totalTokens);

        console.log(buildStatusLine(model, currentDir, tokenDisplay, percentage));
    } catch (error) {
        console.error(`Status line error: ${error.message}`);
        console.log(buildErrorStatusLine());
    }
}

main();
