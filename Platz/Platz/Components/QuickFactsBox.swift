//
//  QuickFactsBox.swift
//  Platz
//
//  Quick Facts 박스 컴포넌트
//

import SwiftUI

struct QuickFactsBox: View {
    let facts: [QuickFact]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.sm) {
            // Header
            HStack {
                Image(systemName: "list.bullet.clipboard.fill")
                    .foregroundColor(PlatzColors.primary)
                Text("Quick Facts")
                    .font(PlatzTypography.bodyBold)
                    .foregroundColor(PlatzColors.textPrimary)
            }
            
            Divider()
                .background(PlatzColors.border)
            
            // Facts Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: PlatzSpacing.sm) {
                ForEach(facts) { fact in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(fact.key)
                            .font(PlatzTypography.caption)
                            .foregroundColor(PlatzColors.textMuted)
                        
                        Text(fact.value)
                            .font(PlatzTypography.bodyBold)
                            .foregroundColor(PlatzColors.textPrimary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surfaceRaised)
        .cornerRadius(PlatzRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.medium)
                .stroke(PlatzColors.primary.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Dialog Bubble
struct DialogBubble: View {
    let line: DialogLine
    let showTranslation: Bool
    let isLeft: Bool
    @ObservedObject var speechManager = SpeechManager.shared
    
    var isCurrentlySpeaking: Bool {
        speechManager.currentlySpeakingText == line.de && speechManager.isSpeaking
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: PlatzSpacing.xs) {
            if !isLeft { Spacer() }
            
            if isLeft {
                speakerButton
            }
            
            VStack(alignment: isLeft ? .leading : .trailing, spacing: PlatzSpacing.xxs) {
                // Speaker
                Text(line.speaker)
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.primary)
                
                // German text
                Text(line.de)
                    .font(PlatzTypography.body)
                    .foregroundColor(PlatzColors.textPrimary)
                
                // Korean translation (if visible)
                if showTranslation {
                    Text(line.ko)
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textSecondary)
                }
                
                // Note (if exists)
                if let note = line.note {
                    Text(note)
                        .font(.system(size: 11))
                        .foregroundColor(PlatzColors.textMuted)
                        .italic()
                }
            }
            .padding(PlatzSpacing.sm)
            .background(isLeft ? PlatzColors.surface : PlatzColors.surfaceRaised)
            .cornerRadius(PlatzRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: PlatzRadius.medium)
                    .stroke(isCurrentlySpeaking ? PlatzColors.primary : PlatzColors.border, lineWidth: 1)
            )
            
            if !isLeft {
                speakerButton
            }
            
            if isLeft { Spacer() }
        }
    }
    
    private var speakerButton: some View {
        Button {
            speechManager.speak(line.de)
        } label: {
            Image(systemName: isCurrentlySpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                .font(.system(size: 14))
                .foregroundColor(isCurrentlySpeaking ? PlatzColors.primary : PlatzColors.textMuted)
                .padding(8)
                .background(PlatzColors.surface)
                .clipShape(Circle())
                .overlay(Circle().stroke(PlatzColors.border, lineWidth: 1))
        }
        .padding(.bottom, 4)
    }
}

// MARK: - Keyword Chip
struct KeywordChip: View {
    let keyword: DialogKeyword
    @ObservedObject var speechManager = SpeechManager.shared
    
    var body: some View {
        Button {
            speechManager.speak(keyword.word)
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(keyword.word)
                        .font(PlatzTypography.bodyBold)
                        .foregroundColor(PlatzColors.primary)
                    
                    Image(systemName: "speaker.wave.1")
                        .font(.system(size: 10))
                        .foregroundColor(PlatzColors.primary.opacity(0.7))
                }
                
                Text(keyword.meaning)
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, PlatzSpacing.sm)
            .padding(.vertical, PlatzSpacing.xs)
            .background(PlatzColors.tag)
            .cornerRadius(PlatzRadius.small)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Example Card
struct ExampleCard: View {
    let example: LessonExample
    @ObservedObject var speechManager = SpeechManager.shared
    
    var isCurrentlySpeaking: Bool {
        speechManager.currentlySpeakingText == example.de && speechManager.isSpeaking
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
            // German
            HStack(alignment: .firstTextBaseline) {
                Text(example.de)
                    .font(PlatzTypography.title3)
                    .foregroundColor(PlatzColors.textPrimary)
                
                Spacer()
                
                Button {
                    speechManager.speak(example.de)
                } label: {
                    Image(systemName: isCurrentlySpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                        .foregroundColor(isCurrentlySpeaking ? PlatzColors.primary : PlatzColors.textMuted)
                }
            }
            
            // Pronunciation (if exists)
            if let pronunciation = example.pronunciation {
                Text("[\(pronunciation)]")
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.primary)
            }
            
            // Korean
            Text(example.ko)
                .font(PlatzTypography.body)
                .foregroundColor(PlatzColors.textSecondary)
            
            // Note (if exists)
            if let note = example.note {
                Text(note)
                    .font(PlatzTypography.caption)
                    .foregroundColor(PlatzColors.textMuted)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(PlatzSpacing.md)
        .background(PlatzColors.surface)
        .cornerRadius(PlatzRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: PlatzRadius.medium)
                .stroke(isCurrentlySpeaking ? PlatzColors.primary : PlatzColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Tip Box
struct TipBox: View {
    let tips: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlatzSpacing.xs) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(PlatzColors.warning)
                Text("팁")
                    .font(PlatzTypography.captionBold)
                    .foregroundColor(PlatzColors.warning)
            }
            
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: PlatzSpacing.xs) {
                    Text("•")
                        .foregroundColor(PlatzColors.textMuted)
                    Text(tip)
                        .font(PlatzTypography.caption)
                        .foregroundColor(PlatzColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(PlatzSpacing.md)
        .background(PlatzColors.warning.opacity(0.1))
        .cornerRadius(PlatzRadius.medium)
    }
}

// MARK: - Progress Ring
struct ProgressRing: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(PlatzColors.border, lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    PlatzColors.primary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Percentage text
            Text("\(Int(progress * 100))%")
                .font(PlatzTypography.bodyBold)
                .foregroundColor(PlatzColors.textPrimary)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            QuickFactsBox(facts: [
                QuickFact(key: "수도", value: "베를린"),
                QuickFact(key: "인구", value: "8,300만"),
                QuickFact(key: "면적", value: "357,000km²"),
                QuickFact(key: "공용어", value: "독일어")
            ])
            
            ExampleCard(example: LessonExample(
                de: "Guten Tag",
                ko: "좋은 하루",
                note: "낮 시간대 인사",
                pronunciation: "구텐 탁"
            ))
            
            TipBox(tips: [
                "항상 관사와 함께 단어를 외우세요",
                "발음 연습을 꾸준히 하세요"
            ])
            
            ProgressRing(progress: 0.65, size: 80, lineWidth: 8)
        }
        .padding()
    }
    .background(PlatzColors.background)
}
