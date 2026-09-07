export const StudentType = {
    pureMathsStudent: "pure_maths_student",
    mathsLiteracyStudent: "maths_literacy_student",
}

export type StudentType = typeof StudentType[keyof typeof StudentType];
