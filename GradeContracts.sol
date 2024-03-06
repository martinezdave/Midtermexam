// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract GradeControl {
    address public owner;
    enum GradeStatus { Pass, Fail }

    struct Student {
        string name;
        uint256 prelimGrade;
        uint256 midtermGrade;
        uint256 finalGrade;
        GradeStatus status;
    }

    mapping(address => Student) public students;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can set grade and compute and call this function");
        _;
    }

    modifier isValidGrade(uint256 grade) {
        require(grade >= 0 && grade <= 100, "Invalid grade value");
        _;
    }

    event GradeComputed(string indexed studentName, GradeStatus status);

    constructor() {
        owner = msg.sender;
    }

    function setName(string memory name, address studentAddress) external onlyOwner {
        students[studentAddress].name = name;
    }

    function setPrelimGrade(uint256 grade,address studentAddress ) external onlyOwner isValidGrade(grade) {
        students[studentAddress].prelimGrade = grade;
    }

    function setMidtermGrade(uint256 grade, address studentAddress) external onlyOwner isValidGrade(grade) {
        students[studentAddress].midtermGrade = grade;
    }

    function setFinalGrade(uint256 grade, address studentAddress) external onlyOwner isValidGrade(grade) {
        students[studentAddress].finalGrade = grade;
    }

    function calculateGrade(address studentAddress) external onlyOwner {
        Student storage student = students[studentAddress];
        uint256 overallGrade = (student.prelimGrade + student.midtermGrade + student.finalGrade) / 3;

        if (overallGrade >= 60) {
            student.status = GradeStatus.Pass;
        } else {
            student.status = GradeStatus.Fail;
        }

        emit GradeComputed(student.name, student.status);
    }
}
