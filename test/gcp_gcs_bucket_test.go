package test

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"os"
	"testing"

	"cloud.google.com/go/storage"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testStructure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"google.golang.org/api/option"
)

func getOptions(t *testing.T, directory string) *terraform.Options {
	return terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: directory,
	})
}

func TestGCSBucketCreation(t *testing.T) {
	credentials := os.Getenv("TF_VAR_google_credentials")

	t.Run("success", func(t *testing.T) {
		t.Parallel()

		options := getOptions(t, testStructure.CopyTerraformFolderToTemp(t, "..", "examples/bucket"))

		defer terraform.Destroy(t, options)

		fmt.Println("<------------InitAndApply started ------------->")
		_, err := terraform.InitAndApplyE(t, options)
		fmt.Println("Init and apply err ===>", err)
		assert.NoError(t, err)

		fmt.Println("All output====>", terraform.OutputAll(t, options))
		id := terraform.Output(t, options, "test_bucket_id")
		assert.NotEmpty(t, id)

		name := terraform.Output(t, options, "test_bucket_name")
		assert.NotEmpty(t, name)

		id_retention := terraform.Output(t, options, "test_bucket_with_retention_id")
		assert.NotEmpty(t, id_retention)

		name_retention := terraform.Output(t, options, "test_bucket_with_retention_name")
		assert.NotEmpty(t, name_retention)

		ctx := context.Background()
		client, err := storage.NewClient(ctx, option.WithCredentialsJSON([]byte(credentials)))
		if err != nil {
			t.Fatal(err)
		}

		bucket := client.Bucket(name)
		obj := bucket.Object("test")
		w := obj.NewWriter(ctx)

		_, err = fmt.Fprintf(w, "test content\n")
		assert.NoError(t, err)

		err = w.Close()
		assert.NoError(t, err)

		r, err := obj.NewReader(ctx)
		assert.NoError(t, err)
		defer func() {
			err = r.Close()
			assert.NoError(t, err)
		}()

		var b bytes.Buffer
		_, err = io.Copy(&b, r)
		assert.NoError(t, err)
	})
}
