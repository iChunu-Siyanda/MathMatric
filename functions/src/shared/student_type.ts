export const StudentType = {
    pureMathsStudent: "pure_maths_students",
    mathsLiteracyStudent: "maths_literacy_students",
}

export type StudentType = typeof StudentType[keyof typeof StudentType];
