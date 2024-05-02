codeunit 80100 Operations
{

    TableNo = "HeadLine Variable";

    var
        OperationRecRef: RecordRef;
        IsSet, Success : Boolean;
        VariableResultAsText, AllowedFieldTypesTxt : Text;
        CalculationError: Label 'An error has ocurred while calculating %1\Error: %2', comment = 'ESP="Ha ocurrido un error al calcular %1\Error: %2"';
        RecRefNotSetErr: Label 'RecordRef not set', comment = 'ESP="RecordRef no establecido"';
        TypeError: Label 'Field is of type %1\Allowed types %2', comment = 'ESP="El campo es de tipo %1\Tipos permitidos %2"';

    trigger OnRun()
    var
        recView, OperationResult : Text;
    begin
        recView := Rec.GetVariableRecordTableView();

        OperationRecRef.Open(Rec.TableNo);
        OperationRecRef.SetView(recView);
        IsSet := true;

        if RunOperation(Rec, OperationResult) then begin
            VariableResultAsText := OperationResult;
        end else
            VariableResultAsText := StrSubstNo(CalculationError, Rec.RecordId, GetLastErrorText());
    end;

    /// <summary>
    /// Tries to run the specified operation on the specified variable record and fills the result in the OperationResult variable
    /// </summary>
    /// <param name="Rec">The Headline Variable Record</param>
    /// <param name="OperationResult">The result of the specified operation that will be filled by the function</param>
    /// <returns>True if the operation is completed successfully, false otherwise and catches the error</returns>
    [TryFunction]
    procedure RunOperation(var Rec: Record "HeadLine Variable"; var OperationResult: Text)
    var
        IntResult: Integer;
        DecimalResult: Decimal;
        TextResult: Text;
        BoolResult: Boolean;
    begin
        if not IsSet then
            Error(RecRefNotSetErr);

        case Rec."Calc. Operation" of
            "Calc. Operation"::Count:
                begin
                    CountRecords(IntResult);
                    OperationResult := Format(IntResult);
                end;
            "Calc. Operation"::Sum:
                begin
                    SumField(Rec.FieldNo, DecimalResult);
                    OperationResult := Format(DecimalResult);
                end;
            "Calc. Operation"::Avg:
                begin
                    AverageField(Rec.FieldNo, DecimalResult);
                    OperationResult := Format(DecimalResult);
                end;
            "Calc. Operation"::Max:
                begin
                    MaxField(Rec.FieldNo, TextResult);
                    OperationResult := TextResult;
                end;
            "Calc. Operation"::Min:
                begin
                    MinField(Rec.FieldNo, TextResult);
                    OperationResult := TextResult;
                end;
            "Calc. Operation"::Lookup:
                begin
                    LookupField(Rec.FieldNo, TextResult);
                    OperationResult := TextResult;
                end;
            "Calc. Operation"::Exist:
                begin
                    ExistRecord(BoolResult);
                    OperationResult := Format(BoolResult);
                end;
            else
                OnCalcOtherOperation(Rec, OperationResult);
        end;

        Success := true;
    end;

    /// <summary>
    /// Gets the value of the global variable in which the operation result is stored
    /// </summary>
    /// <returns>The value obtained from the operation</returns>
    procedure GetValue(): Text
    begin
        if not Success then
            Error(CalculationError, OperationRecRef.RecordId, GetLastErrorText());

        exit(VariableResultAsText);
    end;

    #region Operation Methods

    local procedure CountRecords(var RecordCount: Integer)
    begin
        RecordCount := OperationRecRef.Count();
    end;

    local procedure SumField(FieldNo: Integer; var FieldSum: Decimal)
    var
        fieldRef: FieldRef;
        fieldDecimalValue: Decimal;
    begin
        fieldRef := OperationRecRef.Field(FieldNo);

        if not (fieldRef.Type() in [FieldType::Integer, FieldType::Decimal]) then begin
            AllowedFieldTypesTxt := StrSubstNo('%1, %2', FieldType::Integer, FieldType::Decimal);
            Error(TypeError, fieldRef.Type(), AllowedFieldTypesTxt);
        end;

        if OperationRecRef.FindSet() then
            repeat
                if fieldRef.Class() = FieldClass::FlowField then
                    fieldRef.CalcField();

                fieldDecimalValue := fieldRef.Value();
                FieldSum += fieldDecimalValue;
            until OperationRecRef.Next() = 0;
    end;

    local procedure AverageField(FieldNo: Integer; var FieldAvg: Decimal)
    var
        fieldRef: FieldRef;
        fieldDecimalValue: Decimal;
        RecordCount: Integer;
        FieldSum: Decimal;
    begin
        SumField(FieldNo, FieldSum);
        CountRecords(RecordCount);

        if RecordCount <> 0 then
            FieldAvg := FieldSum / RecordCount;
    end;

    local procedure MaxField(FieldNo: Integer; var FieldMax: Text)
    var
        fieldRef: FieldRef;
    begin
        fieldRef := OperationRecRef.Field(FieldNo);

        if fieldRef.Class() = FieldClass::FlowField then
            fieldRef.CalcField();

        FieldMax := Format(fieldRef.GetRangeMax());
    end;

    local procedure MinField(FieldNo: Integer; var FieldMin: Text)
    var
        fieldRef: FieldRef;
    begin
        fieldRef := OperationRecRef.Field(FieldNo);

        if fieldRef.Class() = FieldClass::FlowField then
            fieldRef.CalcField();

        FieldMin := Format(fieldRef.GetRangeMin());
    end;

    local procedure LookupField(FieldNo: Integer; var FieldValue: Text)
    var
        fieldRef: FieldRef;
    begin
        fieldRef := OperationRecRef.Field(FieldNo);

        if fieldRef.Class() = FieldClass::FlowField then
            fieldRef.CalcField();

        FieldValue := Format(fieldRef.Value());
    end;

    local procedure ExistRecord(var RecordExists: Boolean)
    begin
        RecordExists := not OperationRecRef.IsEmpty();
    end;

    #endregion Operation Methods

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnCalcOtherOperation(var Rec: Record "HeadLine Variable"; var OperationResult: Text)
    begin
    end;

    #endregion Integration Events
}