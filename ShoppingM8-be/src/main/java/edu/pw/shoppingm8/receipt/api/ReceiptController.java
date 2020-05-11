package edu.pw.shoppingm8.receipt.api;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.list.ListService;
import edu.pw.shoppingm8.receipt.Receipt;
import edu.pw.shoppingm8.receipt.ReceiptService;
import edu.pw.shoppingm8.receipt.exception.MultipartFileException;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.Authorization;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URI;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/list/{listId}/receipt")
@RequiredArgsConstructor
public class ReceiptController {
    private final ListService listService;
    private final ReceiptService receiptService;

    @ApiOperation(value = "Get list receipts", nickname = "get list receipts", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid list id was provided", response = Iterable.class)})
    @ApiResponse(code = 404, message = "If invalid list id was provided")
    @GetMapping
    public ResponseEntity<Iterable<ReceiptDto>> getReceiptsByList(@PathVariable Long listId) {
        List list = listService.getList(listId);
        listService.checkIfUserHasAccessTo(list);
        return ResponseEntity.ok(
                receiptService.getReceiptsByList(list)
                        .stream().map(ReceiptDto::of).collect(Collectors.toList()));
    }

    @ApiOperation(value = "Get receipt", nickname = "get receipt", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "If valid id was provided", response = InputStreamResource.class),
            @ApiResponse(code = 404, message = "If invalid id was provided")})
    @GetMapping("{id}")
    public ResponseEntity<InputStreamResource> getReceipt(@PathVariable Long listId, @PathVariable Long id) {
        List list = listService.getList(listId);
        listService.checkIfUserHasAccessTo(list);
        Receipt receipt = receiptService.getReceipt(list, id);
        return ResponseEntity.ok(new InputStreamResource(new ByteArrayInputStream(receipt.getPicture())));
    }

    @ApiOperation(value = "Create receipt", nickname = "create receipt", notes = "",
            authorizations = {@Authorization(value = "JWT")})
    @ApiResponses(value = {
            @ApiResponse(code = 201, message = "If valid data was provided"),
            @ApiResponse(code = 400, message = "If invalid data was provided"),
            @ApiResponse(code = 403, message = "If user does not have access to the list"),
            @ApiResponse(code = 404, message = "If invalid list id was provided")})
    @PostMapping
    public ResponseEntity<ReceiptDto> createReceipt(@PathVariable Long listId,
                                                    @RequestPart("picture") MultipartFile picture) {
        List list = listService.getList(listId);
        listService.checkIfUserHasAccessTo(list);
        Receipt receipt = null;
        try {
            receipt = receiptService.createReceipt(picture.getBytes(), list);
            return ResponseEntity
                    .created(URI.create(String.format("/list/%d/receipt/%d", listId, receipt.getId())))
                    .contentType(MediaType.IMAGE_JPEG)
                    .body(ReceiptDto.of(receipt));
        } catch (IOException e) {
            throw new MultipartFileException();
        }
    }
}
