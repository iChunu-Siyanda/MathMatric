export const validStudentTypes = [
  "pure_maths_student",
  "maths_literacy_student",
] as const;

export type StudentType = typeof validStudentTypes[number];

export function isStudentType(value: string): value is StudentType {
  return validStudentTypes.includes(value as StudentType);
}
